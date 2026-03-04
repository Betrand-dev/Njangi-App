import os
from datetime import datetime, timedelta
from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_jwt_extended import (
    JWTManager,
    create_access_token,
    create_refresh_token,
    jwt_required,
    get_jwt_identity,
    get_jwt,
)
import bcrypt
import mysql.connector
from mysql.connector import Error

# DB config (update these to match your XAMPP setup)
DB_HOST = os.getenv("DB_HOST", "127.0.0.1")
DB_PORT = int(os.getenv("DB_PORT", "3306"))
DB_USER = os.getenv("DB_USER", "root")
DB_PASSWORD = os.getenv("DB_PASSWORD", "")
DB_NAME = os.getenv("DB_NAME", "ncap_db")

def get_db():
    return mysql.connector.connect(
        host=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
        autocommit=False,
    )

app = Flask(__name__)
CORS(app)
app.config["JWT_SECRET_KEY"] = os.getenv("JWT_SECRET_KEY", "change_this_to_a_strong_secret")
app.config["JWT_ACCESS_TOKEN_EXPIRES"] = int(os.getenv("JWT_ACCESS_TOKEN_EXPIRES", 60 * 60))  # 1 hour
app.config["JWT_REFRESH_TOKEN_EXPIRES"] = int(os.getenv("JWT_REFRESH_TOKEN_EXPIRES", 60 * 60 * 24 * 30))  # 30 days

jwt = JWTManager(app)


# Helpers: DB operations
def fetch_one(query, params=()):
    cnx = get_db()
    cur = cnx.cursor(dictionary=True)
    cur.execute(query, params)
    row = cur.fetchone()
    cur.close()
    cnx.close()
    return row

def execute(query, params=(), commit=True):
    cnx = get_db()
    cur = cnx.cursor()
    cur.execute(query, params)
    if commit:
        cnx.commit()
    lastrowid = cur.lastrowid
    cur.close()
    cnx.close()
    return lastrowid

def execute_many(cur, query, params_list):
    cur.executemany(query, params_list)


# JWT blocklist check using refresh_tokens table
@jwt.token_in_blocklist_loader
def check_if_token_revoked(jwt_header, jwt_payload):
    jti = jwt_payload.get("jti")
    try:
        row = fetch_one("SELECT revoked FROM refresh_tokens WHERE jti = %s", (jti,))
        # Only revoke if the token exists in the table AND is marked as revoked
        return row is not None and row.get("revoked", 0) == 1
    except Exception:
        return False  # Default to not revoked on error


# Auth endpoints
@app.route("/auth/register", methods=["POST"])
def register():
    data = request.get_json() or {}
    email = (data.get("email") or "").strip().lower()
    password = data.get("password", "")
    if not email or not password:
        return jsonify({"message": "Email and password required"}), 400

    existing = fetch_one("SELECT id FROM users WHERE email = %s", (email,))
    if existing:
        return jsonify({"message": "User already exists"}), 400

    hashed = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt())
    try:
        execute(
            """
            INSERT INTO users (email, password_hash, first_name, last_name, phone)
            VALUES (%s,%s,%s,%s,%s)
            """,
            (email, hashed.decode("utf-8"), data.get("firstName"), data.get("lastName"), data.get("phone")),
        )
        return jsonify({"message": "User created"}), 201
    except Error as e:
        return jsonify({"message": "DB error", "error": str(e)}), 500


@app.route("/auth/login", methods=["POST"])
def login():
    data = request.get_json() or {}
    email = (data.get("email") or "").strip().lower()
    password = data.get("password", "")
    if not email or not password:
        return jsonify({"message": "Email and password required"}), 400

    user = fetch_one("SELECT id, password_hash FROM users WHERE email = %s", (email,))
    if not user:
        return jsonify({"message": "Invalid credentials"}), 401

    if not bcrypt.checkpw(password.encode("utf-8"), user["password_hash"].encode("utf-8")):
        return jsonify({"message": "Invalid credentials"}), 401

    access_token = create_access_token(identity=str(user["id"]))  # Use user ID as identity
    refresh_token = create_refresh_token(identity=str(user["id"]))

    # Store refresh token
    jti = get_jti_from_token(refresh_token)
    try:
        expires_at = datetime.utcnow() + timedelta(seconds=app.config["JWT_REFRESH_TOKEN_EXPIRES"])
        execute(
            """
            INSERT INTO refresh_tokens (jti, token, user_id, revoked, expires_at)
            VALUES (%s,%s,%s,0,%s)
            """,
            (jti, refresh_token, user["id"], expires_at),
        )
    except Error:
        pass

    return jsonify({"access_token": access_token, "refresh_token": refresh_token}), 200


def get_jti_from_token(token):
    from flask_jwt_extended.utils import decode_token
    decoded = decode_token(token)
    return decoded.get("jti")


@app.route("/auth/refresh", methods=["POST"])
@jwt_required(refresh=True)
def refresh():
    identity = get_jwt_identity()
    print(identity)
    new_access = create_access_token(identity=identity)
    return jsonify({"access_token": new_access}), 200


@app.route("/auth/logout_refresh", methods=["POST"])
@jwt_required(refresh=True)
def logout_refresh():
    payload = get_jwt()
    jti = payload.get("jti")
    try:
        execute("UPDATE refresh_tokens SET revoked = 1 WHERE jti = %s", (jti,))
    except Exception:
        pass
    return jsonify({"message": "Refresh token revoked"}), 200


@app.route("/auth/me", methods=["GET"])
@jwt_required()
def me():
    identity = get_jwt_identity()
    print(identity)
    user = fetch_one("SELECT id, email, first_name, last_name, phone, created_at, balance FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404
    profile = {
        "id": user["id"],
        "email": user["email"],
        "firstName": user.get("first_name"),
        "lastName": user.get("last_name"),
        "phone": user.get("phone"),
        "created_at": user.get("created_at").isoformat() if user.get("created_at") else None,
        "balance": user.get("balance"),
    }
    print(profile)
    return jsonify(profile), 200


# deposit to update user's balance
@app.route("/deposit", methods=["POST"])
@jwt_required()
def deposit():
    data = request.get_json() or {}
    print(data)
    amount = int(data.get("depositAmount"))
    identity = get_jwt_identity()
    user = fetch_one("SELECT id FROM users WHERE id = %s", (identity,))
    print(user["id"])
    if not user:
        return jsonify({"message": "User not found"}), 404
    cnx = get_db()
    cur = cnx.cursor()
    try:
        cur.execute("UPDATE users SET balance = balance + %s WHERE id = %s",(amount,user["id"]))
        cnx.commit()
    except Exception as e:
        cnx.rollback()
        return jsonify({"message": "Failed to update balance", "error": str(e)}), 500
    finally:
        cur.close()
        cnx.close()
    return jsonify({"message": "Updated Balance"}), 200

@app.route("/deposit", methods=["GET"])
@jwt_required()
def get_balance():
    identity = get_jwt_identity()
    user = fetch_one("SELECT id FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404
    cnx = get_db()
    cur = cnx.cursor()
    try:
        cnx.start_transaction()
        cur.execute(""" SELECT balance FROM users WHERE id = %s""",(user["id"],))
        balance = cur.fetchone()
    except Exception as e:
        cnx.rollback()
        print(e)
        return jsonify({"message": "Failed to get balance", "error": str(e)}), 500
    finally:
        cur.close()
        cnx.close()
    return jsonify({"balance": balance}), 200


# withdrawal route
@app.route("/withdrawal", methods=["POST"])
@jwt_required()
def withdrawal():
    data = request.get_json() or {}
    print(data)
    amount = int(data.get("withdrawalAmount"))
    identity = get_jwt_identity()
    user = fetch_one("SELECT id, balance FROM users WHERE id = %s", (identity,))
    print(user)
    if not user:
        return jsonify({"message": "User not found"}), 404
    if amount > user['balance']:
        return jsonify({"message":"insufficient balance"}), 300
    cnx = get_db()
    cur = cnx.cursor()
    try:
        cur.execute("UPDATE users SET balance = balance - %s WHERE id = %s",(amount,user["id"]))
        cnx.commit()
    except Exception as e:
        cnx.rollback()
        return jsonify({"message": "Failed to withdraw", "error": str(e)}), 500
    finally:
        cur.close()
        cnx.close()
    return jsonify({"message": "withdraw successful"}), 200

# Groups and membership
def generate_unique_code(length=6):
    import random, string
    cnx = get_db()
    cur = cnx.cursor()
    try:
        while True:
            code = "".join(random.choices(string.ascii_uppercase + string.digits, k=length))
            cur.execute("SELECT id FROM groups WHERE code = %s", (code,))
            if not cur.fetchone():
                return code
    finally:
        cur.close()
        cnx.close()


@app.route("/groups", methods=["POST"])
@jwt_required()
def create_group():
    data = request.get_json() or {}
    name = data.get("name")
    description = data.get("description")
    frequency = data.get("frequency")
    start_date = data.get("start_date")
    amount = data.get("contribution_amount")
    group_type = data.get("type")
    penalty = data.get("penalty")
    contribution_time = data.get("contribution_time")
    end_date = data.get("end_date")
    max_members = data.get("max_members")
    if not name:
        return jsonify({"message": "Group name required"}), 400

    identity = get_jwt_identity()
    user = fetch_one("SELECT id FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404
    user_id = user["id"]

    cnx = get_db()
    cur = cnx.cursor()
    try:
        cnx.start_transaction()
        code = generate_unique_code()
        cur.execute(
            """
            INSERT INTO groups (name, code, description, admin_id, balance, frequency, start_date, contribution_amount, group_type, penalty, contribution_time, end_date, max_members)
            VALUES (%s,%s,%s,%s,0,%s,%s,%s,%s,%s,%s,%s,%s)
            """,
            (name, code, description, user_id, frequency, start_date, amount, group_type, penalty, contribution_time, end_date, max_members),
        )
        group_id = cur.lastrowid
        cur.execute("INSERT INTO group_members (group_id, user_id, role) VALUES (%s,%s,'admin')", (group_id, user_id))
        cnx.commit()
    except Exception as e:
        cnx.rollback()
        return jsonify({"message": "Failed to create group", "error": str(e)}), 500
    finally:
        cur.close()
        cnx.close()

    return jsonify({"group_code": code}), 201


@app.route("/groups/join", methods=["POST"])
@jwt_required()
def join_group():
    data = request.get_json() or {}
    code = (data.get("code") or "").strip()
    if not code:
        return jsonify({"message": "Group code required"}), 400

    identity = get_jwt_identity()
    user = fetch_one("SELECT id, email FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404
    user_id = user["id"]

    cnx = get_db()
    cur = cnx.cursor(dictionary=True)
    try:
        cur.execute("SELECT id, name FROM groups WHERE code = %s", (code,))
        grp = cur.fetchone()
        if not grp:
            return jsonify({"message": "Group not found"}), 404
        group_id = grp["id"]

        cur.execute("SELECT id FROM group_members WHERE group_id = %s AND user_id = %s", (group_id, user_id))
        if cur.fetchone():
            return jsonify({"message": "Already a member"}), 200

        cur.execute("INSERT INTO group_members (group_id, user_id, role) VALUES (%s,%s,'member')", (group_id, user_id))
        cur.execute(
            "SELECT user_id FROM group_members WHERE group_id = %s AND user_id != %s",
            (group_id, user_id),
        )
        rows = cur.fetchall()
        insert_params = []
        for r in rows:
            insert_params.append((r["user_id"], group_id, user_id, "joined_group", f'{{"member_id":{user_id}}}'))
        if insert_params:
            cur.executemany(
                "INSERT INTO notifications (user_id, group_id, actor_id, type, payload) VALUES (%s,%s,%s,%s,%s)",
                insert_params,
            )
        cnx.commit()
    except Exception as e:
        cnx.rollback()
        return jsonify({"message": "Failed to join group", "error": str(e)}), 500
    finally:
        cur.close()
        cnx.close()

    return jsonify({"message": "Joined group", "group": {"id": group_id, "name": grp["name"]}}), 200


@app.route("/groups", methods=["GET"])
@jwt_required()
def get_user_groups():
    identity = get_jwt_identity()
    user = fetch_one("SELECT id FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404

    # Get all groups where user is a member
    cnx = get_db()
    cur = cnx.cursor(dictionary=True)
    try:
        cur.execute("""
            SELECT g.id, g.name, g.group_type, g.frequency, g.contribution_amount, g.balance
            FROM groups g
            JOIN group_members gm ON g.id = gm.group_id
            WHERE gm.user_id = %s
        """, (user["id"],))
        groups = cur.fetchall()

        # Add member count for each group
        for group in groups:
            cur.execute("SELECT COUNT(*) as count FROM group_members WHERE group_id = %s", (group["id"],))
            group["members"] = cur.fetchone()["count"]

    finally:
        cur.close()
        cnx.close()

    return jsonify({"groups": groups}), 200


@app.route("/groups/<int:group_id>", methods=["GET"])
@jwt_required()
def get_group(group_id):
    identity = get_jwt_identity()
    user = fetch_one("SELECT id FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404

    mem = fetch_one("SELECT role FROM group_members WHERE group_id = %s AND user_id = %s", (group_id, user["id"]))
    if not mem:
        return jsonify({"message": "Forbidden - not a member"}, 403)

    group = fetch_one("""
        SELECT id, name, code, description, admin_id, balance, frequency, start_date, 
               end_date, contribution_amount, group_type, penalty, 
               max_members, created_at 
        FROM groups WHERE id = %s
    """, (group_id,))

    if not group:
        return jsonify({"message": "Group not found"}), 404

    members = []
    cnx = get_db()
    cur = cnx.cursor(dictionary=True)
    try:
        cur.execute(
            "SELECT u.id, u.email, u.first_name AS firstName, u.last_name AS lastName, gm.role FROM users u JOIN group_members gm ON u.id = gm.user_id WHERE gm.group_id = %s",
            (group_id,),
        )
        members = cur.fetchall()
    finally:
        cur.close()
        cnx.close()

    return jsonify({"group": group, "members": members}), 200

# mine adding

# Admin endpoints for group management

@app.route("/groups/<int:group_id>/members/<int:member_id>", methods=["DELETE"])
@jwt_required()
def remove_member(group_id, member_id):
    identity = get_jwt_identity()
    user = fetch_one("SELECT id FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404

    # Check if current user is admin of the group
    admin_check = fetch_one("SELECT role FROM group_members WHERE group_id = %s AND user_id = %s",
                            (group_id, user["id"]))
    if not admin_check or admin_check["role"] != "admin":
        return jsonify({"message": "Forbidden - admin only"}), 403

    # Cannot remove yourself
    if member_id == user["id"]:
        return jsonify({"message": "Cannot remove yourself from the group"}), 400

    # Check if member exists in group
    member_check = fetch_one("SELECT id FROM group_members WHERE group_id = %s AND user_id = %s", (group_id, member_id))
    if not member_check:
        return jsonify({"message": "Member not found in this group"}), 404

    # Remove member
    execute("DELETE FROM group_members WHERE group_id = %s AND user_id = %s", (group_id, member_id))

    # Create notification for removed member
    execute("INSERT INTO notifications (user_id, group_id, actor_id, type, payload) VALUES (%s,%s,%s,%s,%s)",
            (member_id, group_id, user["id"], "removed_from_group", '{}'))

    return jsonify({"message": "Member removed successfully"}), 200

# delete group
@app.route("/delete_group/<int:group_id>", methods=["DELETE"])
@jwt_required()
def remove_group(group_id):
    identity = get_jwt_identity()
    user = fetch_one("SELECT id FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404

    # Check if current user is admin of the group
    admin_check = fetch_one("SELECT role FROM group_members WHERE group_id = %s AND user_id = %s",
                            (group_id, user["id"]))
    if not admin_check or admin_check["role"] != "admin":
        return jsonify({"message": "Forbidden - admin only"}), 403


    # Remove Group
    execute("DELETE FROM groups WHERE id = %s", (group_id,))

    return jsonify({"message": "group deleted successfully"}), 200


# delete profiles
@app.route("/delete_saving_profile/<int:id>", methods=["DELETE"])
@jwt_required()
def remove_saving_profile(id):
    identity = get_jwt_identity()
    user = fetch_one("SELECT id FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404

    # Remove Group
    execute("DELETE FROM savings_profiles WHERE id = %s", (id,))

    return jsonify({"message": "profile deleted successfully"}), 200


@app.route("/delete_expense_profile/<int:id>", methods=["DELETE"])
@jwt_required()
def remove_expense_profile(id):
    identity = get_jwt_identity()
    user = fetch_one("SELECT id FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404

    # Remove Group
    execute("DELETE FROM expense_trackings WHERE id = %s", (id,))

    return jsonify({"message": "profile deleted successfully"}), 200


# Contributions
@app.route("/groups/<int:group_id>/contributions", methods=["POST"])
@jwt_required()
def create_contribution(group_id):
    data = request.get_json() or {}
    amount = data.get("amount")
    note = data.get("note")
    if amount is None:
        return jsonify({"message": "Amount required"}), 400

    identity = get_jwt_identity()
    user = fetch_one("SELECT id FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404
    user_id = user["id"]

    mem = fetch_one("SELECT role FROM group_members WHERE group_id = %s AND user_id = %s", (group_id, user_id))
    if not mem:
        return jsonify({"message": "Forbidden - not a member"}, 403)

    cnx = get_db()
    cur = cnx.cursor()
    try:
        cur.execute(
            """INSERT INTO contributions (group_id, user_id, amount, note, status, created_at)
               VALUES (%s,%s,%s,%s,'pending',NOW())""",
            (group_id, user_id, amount, note),
        )
        contribution_id = cur.lastrowid
        cur.execute("SELECT user_id FROM group_members WHERE group_id = %s", (group_id,))
        rows = cur.fetchall()
        insert_params = []
        for r in rows:
            uid = r[0]
            insert_params.append((uid, group_id, user_id, "contribution_pending", f'{{"contribution_id":{contribution_id}}}'))
            print(insert_params)
        if insert_params:
            cur.executemany(
                "INSERT INTO notifications (user_id, group_id, actor_id, type, payload) VALUES (%s,%s,%s,%s,%s)",
                insert_params,
            )
        cur.execute("UPDATE users SET balance = balance - %s WHERE id = %s",(amount,user_id))
        cnx.commit()
    except Exception as e:
        cnx.rollback()
        print(e)
        return jsonify({"message": "Failed to create contribution", "error": str(e)}), 500
    finally:
        cur.close()
        cnx.close()

    return jsonify({"id": contribution_id, "status": "pending"}), 201


@app.route("/groups/<int:group_id>/contributions/<int:contrib_id>/confirm", methods=["POST"])
@jwt_required()
def confirm_contribution(group_id, contrib_id):
    identity = get_jwt_identity()
    user = fetch_one("SELECT id FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404
    user_id = user["id"]

    role = fetch_one("SELECT role FROM group_members WHERE group_id = %s AND user_id = %s", (group_id, user_id))
    if not role or role["role"] != "admin":
        return jsonify({"message": "Forbidden - admin only"}, 403)

    contribution = fetch_one("SELECT id, status, amount FROM contributions WHERE id = %s AND group_id = %s", (contrib_id, group_id))
    if not contribution:
        return jsonify({"message": "Contribution not found"}, 404)
    if contribution["status"] != "pending":
        return jsonify({"message": "Contribution not pending"}, 400)

    try:
        execute(
            "UPDATE contributions SET status='confirmed', confirmed_by=%s, confirmed_at=NOW() WHERE id = %s",
            (user_id, contrib_id),
        )
        execute("UPDATE groups SET balance = balance + %s WHERE id = %s", (contribution["amount"], group_id))
        cnx = get_db()
        cur = cnx.cursor()
        cur.execute("SELECT user_id FROM group_members WHERE group_id = %s", (group_id,))
        rows = cur.fetchall()
        insert_params = []
        for r in rows:
            uid = r[0]
            insert_params.append((uid, group_id, user_id, "contribution_confirmed", f'{{"contribution_id":{contrib_id}}}'))
        if insert_params:
            cur.executemany(
                "INSERT INTO notifications (user_id, group_id, actor_id, type, payload) VALUES (%s,%s,%s,%s,%s)",
                insert_params,
            )
            cnx.commit()
        cur.close()
        cnx.close()
    except Exception as e:
        return jsonify({"message": "Failed to confirm", "error": str(e)}), 500

    return jsonify({"message": "Contribution confirmed"}), 200

# tryer again
@app.route("/update", methods=["POST"])
@jwt_required()
def update_user_info():
    # get data to update
    data = request.get_json() or {}
    first_name = data.get("firstName")
    last_name = data.get("lastName")
    email = data.get("email")
    phone = data.get("phone")

    # get the current user id to update
    identity = get_jwt_identity()
    user = fetch_one("SELECT id FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404
    user_id = user["id"]

    # connect to db
    cnx = get_db()
    cur = cnx.cursor(dictionary=True)

    # send data to db
    try:
        cur.execute("""UPDATE users SET first_name = %s, last_name = %s, email = %s, phone = %s, updated_at = NOW() WHERE id = %s """,
                    (first_name,last_name,email,phone,user_id))
        cnx.commit()
    except Exception as e:
        print(e)
        return jsonify({"message": "failed to update user info", "error": str(e)}), 500
    finally:
        cur.close()
        cnx.close()
    return jsonify({"message": "user info updated"}), 200



@app.route("/groups/<int:group_id>/contributions", methods=["GET"])
@jwt_required()
def get_group_contributions(group_id):
    identity = get_jwt_identity()
    user = fetch_one("SELECT id FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404

    # Check if user is member of the group
    member_check = fetch_one("SELECT role FROM group_members WHERE group_id = %s AND user_id = %s", (group_id, user["id"]))
    if not member_check:
        return jsonify({"message": "Forbidden - not a member"}), 403

    cnx = get_db()
    cur = cnx.cursor(dictionary=True)
    try:
        cur.execute("""
            SELECT c.id, c.user_id, c.amount, c.status, c.created_at, c.confirmed_at,
                   CONCAT(u.first_name, ' ', u.last_name) as user_name
            FROM contributions c
            JOIN users u ON c.user_id = u.id
            WHERE c.group_id = %s
            ORDER BY c.created_at DESC
        """, (group_id,))
        contributions = cur.fetchall()
    finally:
        cur.close()
        cnx.close()

    return jsonify({"contributions": contributions}), 200

# Notifications
@app.route("/notifications", methods=["GET"])
@jwt_required()
def list_notifications():
    identity = get_jwt_identity()
    user = fetch_one("SELECT id FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404
    user_id = user["id"]

    cnx = get_db()
    cur = cnx.cursor(dictionary=True)
    try:
        cur.execute("SELECT n.id, n.group_id, g.name as group_name, n.actor_id, u.first_name as actor_name, n.type, n.payload, n.read_at, n.created_at  FROM notifications n LEFT JOIN groups g ON n.group_id = g.id LEFT JOIN users u ON n.actor_id = u.id WHERE n.user_id = %s ORDER BY n.created_at DESC LIMIT 50;", (user_id,))
        rows = cur.fetchall()
    finally:
        cur.close()
        cnx.close()

    return jsonify({"notifications": rows}), 200


# for the personal savings and expense tracking

@app.route("/saving_profile", methods=["POST"])
@jwt_required()
def create_saving_profile():
    data = request.get_json() or {}
    name = data.get("name")
    goal = data.get("goal")
    target_date = data.get("targetDate")
    frequency = data.get("frequency")
    if not name:
        return jsonify({"message": "profile name required"}), 400

    identity = get_jwt_identity()
    user = fetch_one("SELECT id FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404
    user_id = user["id"]

    cnx = get_db()
    cur = cnx.cursor()
    try:
        cnx.start_transaction()
        cur.execute(
            """
            INSERT INTO savings_profiles (user_id,name,goal_amount,target_date,frequency)
            VALUES (%s,%s,%s,%s,%s)
            """,
            (user_id, name, goal, target_date, frequency),
        )
        cnx.commit()
    except Exception as e:
        cnx.rollback()
        return jsonify({"message": "Failed to create saving Profile", "error": str(e)}), 500
    finally:
        cur.close()
        cnx.close()

    return jsonify({"message": "success"}), 201


@app.route("/saving_profile", methods=["GET"])
@jwt_required()
def get_saving_profile():
    identity = get_jwt_identity()
    user = fetch_one("SELECT id FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404

    # Get all profiles for the user
    cnx = get_db()
    cur = cnx.cursor(dictionary=True)
    try:
        cur.execute(""" SELECT id, name, goal_amount, frequency, target_date FROM savings_profiles WHERE user_id = %s""", (user["id"],))
        profile = cur.fetchall()

    finally:
        cur.close()
        cnx.close()

    return jsonify({"profile": profile}), 200


@app.route("/expends_profile", methods=["POST"])
@jwt_required()
def create_expends_profile():
    data = request.get_json() or {}
    name = data.get("name")
    description = data.get("description")
    if not name:
        return jsonify({"message": "profile name required"}), 400

    identity = get_jwt_identity()
    user = fetch_one("SELECT id FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404
    user_id = user["id"]

    cnx = get_db()
    cur = cnx.cursor()
    try:
        cnx.start_transaction()
        cur.execute(
            """
            INSERT INTO expense_trackings(user_id,name,description)
            VALUES (%s,%s,%s)
            """,
            (user_id, name, description),
        )
        cnx.commit()
    except Exception as e:
        cnx.rollback()
        return jsonify({"message": "Failed to create expends Profile", "error": str(e)}), 500
    finally:
        cur.close()
        cnx.close()

    return jsonify({"message": "success"}), 201

@app.route("/expends_profile", methods=["GET"])
@jwt_required()
def get_expend_profile():
    identity = get_jwt_identity()
    user = fetch_one("SELECT id FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404

    # Get all profiles for the user
    cnx = get_db()
    cur = cnx.cursor(dictionary=True)
    try:
        cur.execute(""" SELECT id, name, description FROM expense_trackings WHERE user_id = %s""", (user["id"],))
        profile = cur.fetchall()

    finally:
        cur.close()
        cnx.close()

    return jsonify({"profile": profile}), 200


@app.route("/savings/<int:id>", methods=["POST"])
@jwt_required()
def create_savings(id):
    data = request.get_json() or {}
    print(data)
    profile_id = int(id)
    value = data.get("value")
    price = int(value)
    identity = get_jwt_identity()
    user = fetch_one("SELECT id FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404
    user_id = user["id"]
    # connect to database
    cnx = get_db()
    cur = cnx.cursor(dictionary=True)
    try:
        cnx.start_transaction()
        cur.execute(" INSERT INTO savings_contributions(profile_id,amount) VALUES (%s,%s)", (profile_id,price))
        cnx.commit()

    except Exception as e:
        cnx.rollback()
        print("error")
        return jsonify({"message": "Failed to create saving ", "error": str(e)}), 500
    finally:
        cur.close()
        cnx.close()

    return jsonify({"message": "success"}), 201


@app.route("/expend/<int:id>", methods=["POST"])
@jwt_required()
def create_expense(id):
    data = request.get_json() or {}
    print(data)
    item = data.get("item")
    describe = data.get("describe")
    amount = int(data.get("amount"))
    identity = get_jwt_identity()
    user = fetch_one("SELECT id FROM users WHERE id = %s", (identity,))
    if not user:
        return jsonify({"message": "User not found"}), 404
    user_id = user["id"]
    # connect to database
    cnx = get_db()
    cur = cnx.cursor()
    try:
        cnx.start_transaction()
        cur.execute(" INSERT INTO expenses(tracking_id,amount,description,merchant) VALUES (%s,%s,%s,%s)", (id,amount,describe,item),)
        cnx.commit()

    except Exception as e:
        cnx.rollback()
        return jsonify({"message": "Failed to create saving ", "error": str(e)}), 500
    finally:
        cur.close()
        cnx.close()

    return jsonify({"message": "success"}), 201


@app.route("/savings/<int:id>", methods=["GET"])
@jwt_required()
def get_savings(id):
    cnx = get_db()
    cur = cnx.cursor(dictionary=True)
    try:
        cur.execute(""" SELECT id, profile_id, created_at, amount FROM savings_contributions WHERE profile_id = %s""", (id,))
        saves = cur.fetchall()
        cur.execute(""" SELECT SUM(amount) AS total_savings FROM savings_contributions WHERE profile_id = %s""",(id,))
        total_savings = cur.fetchone()
        print(total_savings)
    except Exception as e:
        cnx.rollback()
        return jsonify({"message": "Failed to load saving ", "error": str(e)}), 500
    finally:
        cur.close()
        cnx.close()

    return jsonify({"saves": saves, "total_savings": total_savings}), 200


@app.route("/expend/<int:id>", methods=["GET"])
@jwt_required()
def get_expend(id):
    cnx = get_db()
    cur = cnx.cursor(dictionary=True)
    try:
        cur.execute(""" SELECT id, tracking_id, created_at, amount, description, merchant FROM expenses WHERE tracking_id = %s""", (id,))
        expense = cur.fetchall()
        cur.execute(""" SELECT SUM(amount) AS total_expenses FROM expenses WHERE tracking_id = %s""", (id,))
        total_expenses = cur.fetchone()
    except Exception as e:
        cnx.rollback()
        return jsonify({"message": "Failed to load saving ", "error": str(e)}), 500

    finally:
        cur.close()
        cnx.close()

    return jsonify({"expense": expense, "total_expenses": total_expenses}), 200


# end of personal saving and expense tracking

# Utility
@app.route("/protected", methods=["GET"])
@jwt_required()
def protected():
    identity = get_jwt_identity()
    return jsonify({"hello": f"protected data for {identity}"}), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)