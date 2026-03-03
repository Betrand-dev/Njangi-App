import { ChevronRight, Edit } from "lucide-react-native";
import { useContext, useState } from "react";
import {
  ActivityIndicator,
  Alert,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import ButtonBrand from "../../components/ButtonBrand";
import InputBrand from "../../components/InputBrand";
import ModalBrand from "../../components/ModalBrand";
import useModal from "../../hooks/useModal";
import useRequireAuth from "../../hooks/useRequireAuth";
import { AuthContext } from "../contexts/AuthContext";
import api from "../services/api";

const Profile = () => {
  const profileModal = useModal();
  const widthrawal = useModal();
  // handles withdrawal
  const [withdrawalAmount, setwithdrawalAmount] = useState("");
  const isValid = () => {
    return withdrawalAmount.trim() == "";
  };
  const withdraw = async () => {
    const data = {
      withdrawalAmount,
    };
    try {
      const response = await api.post("/withdrawal", data);
      console.log(response.data.message);
      Alert.alert("Withrawal",response.data.message);
    } catch (error) {
      Alert.alert("Withdrawal","Transaction Failed");
      console.error("deposit failed " + error);
    }
  };
  //end of withdrawal
  const { user, loading } = useRequireAuth();
  const { logout } = useContext(AuthContext);
  const [userData, setUserData] = useState({
    firstName: user?.profile?.firstName,
    lastName: user?.profile.lastName,
    email: user?.profile?.email,
    phone: user?.profile?.phone,
  });
  const [isLoading, setIsLoading] = useState(false);

  const updateUserInfo = async () => {
    const data = {
      firstName: userData.firstName,
      lastName: userData.lastName,
      email: userData.email,
      phone: userData.phone,
    };

    setIsLoading(true);

    try {
      const response = await api.post("/update", data);
      Alert.alert("Update", "Information Updated. you are required to login", [
        {
          text: "ok",
          style: "destructive",
          onPress: logout,
        },
      ]);
    } catch (error) {
      Alert.alert("Update", "Failed to Update info");
    } finally {
      setIsLoading(false);
    }
  };

  const updateUserData = (field, value) => {
    setUserData((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  const handleLogout = () => {
    Alert.alert("Logout", "Are you sure you want to logout?", [
      {
        text: "Cancel",
        style: "cancel",
      },
      {
        text: "Logout",
        style: "destructive",
        onPress: logout,
      },
    ]);
  };

  const handleDeleteAccount = () => {
    Alert.alert(
      "Delete Account",
      "Are you sure you want to delete your account? This action cannot be undone.",
      [
        {
          text: "Cancel",
          style: "cancel",
        },
        {
          text: "Delete",
          style: "destructive",
          onPress: async () => {
            try {
              await api.delete("/delete_account");
              Alert.alert("Account Deleted", "Your account has been deleted.", [
                {
                  text: "OK",
                  onPress: logout,
                },
              ]);
            } catch (error) {
              Alert.alert(
                "Error",
                "Failed to delete account. Please try again.",
              );
              console.error("Delete account failed:", error);
            }
          },
        },
      ],
    );
  };

  const isFormValid = () => {
    // destructuring email and password from formData
    const { firstName, lastName, email, phone } = userData;

    // basic validation
    if (
      firstName.trim() !== "" &&
      lastName.trim() !== "" &&
      email.trim() !== "" &&
      phone.trim() !== ""
    ) {
      return false;
    }

    return true;
  };

  const profile = user?.profile;
  return (
    <SafeAreaView className="flex-1 bg-background">
      {/* Header */}
      <View className="flex-row items-center pt-5 pb-5 px-3 border-b border-gray-200  justify-between">
        <View className="flex-row items-center space-x-2">
          <Text className="text-2xl font-semibold">Profile</Text>
        </View>
        <Pressable onPress={profileModal.showModal}>
          <Edit className="text-primary" color="#8f08fdde" />
        </Pressable>
      </View>

      {/* contents */}
      <ScrollView className="space-y-6 pt-3 px-4 pb-4">
        {/* profile */}
        <View className="border border-primary rounded-2xl p-6">
          <View className="bg-primary/10 w-32 h-32 rounded-full self-center flex justify-center items-center">
            <Text className="text-primary text-4xl">
              {profile?.firstName?.[0] + profile?.lastName?.[0]}.
            </Text>
          </View>
          <View className="self-center mt-4">
            <Text className="text-center font-bold text-xl">
              {profile?.firstName} {profile?.lastName}
            </Text>
            <Text className="text-center text-gray-500">{profile?.email}</Text>
          </View>
        </View>

        {/* personal informations */}
        <View className="mt-10  px-4 py-3 bg-white border border-gray-200 rounded-lg">
          <View className="flex flex-row justify-between items-center border-b border-gray-200 p-3">
            <Text className="text-gray-800 font-semibold text-lg">
              First Name
            </Text>
            <Text className="text-gray-800 font-light text-lg">
              {profile?.firstName}
            </Text>
          </View>
          <View className="flex flex-row justify-between items-center border-b border-gray-200 p-3">
            <Text className="text-gray-800 font-semibold text-lg">
              Last Name
            </Text>
            <Text className="text-gray-800 font-light text-lg">
              {profile?.lastName}
            </Text>
          </View>
          <View className="flex flex-row justify-between items-center border-b border-gray-200 p-3">
            <Text className="text-gray-800 font-semibold text-lg">Email</Text>
            <Text className="text-gray-800 font-light">{profile?.email}</Text>
          </View>
          <View className="flex flex-row border-b border-gray-200 justify-between items-center  p-3">
            <Text className="text-gray-800 font-semibold text-lg">
              Phone Number
            </Text>
            <Text className="text-gray-800 font-light text-lg">
              {profile?.phone}
            </Text>
          </View>
          <TouchableOpacity
            className="flex flex-row  justify-between items-center p-3"
            onPress={widthrawal.showModal}
          >
            <Text className="text-primary text-lg">Withdrawal</Text>
            <Text className="text-gray-800 font-light text-lg">
              <ChevronRight color={"#8f08fdde"} />
            </Text>
          </TouchableOpacity>
        </View>

        {/* logout button */}
        <TouchableOpacity
          onPress={handleLogout}
          className="mt-12 flex-row justify-center p-5 bg-red-500 rounded-full mb-2"
        >
          <Text className="font-semibold text-lg text-white">Logout</Text>
        </TouchableOpacity>

        {/* Danger Zone */}
        <View className="mt-10 px-4 py-3 bg-red-50 border border-red-200 rounded-lg">
          <Text className="text-red-600 font-bold text-lg mb-4">
            Danger Zone
          </Text>
          <TouchableOpacity
            onPress={handleDeleteAccount}
            className="flex-row justify-center p-4 bg-red-500 rounded-lg"
          >
            <Text className="font-semibold text-lg text-white">
              Delete Account
            </Text>
          </TouchableOpacity>
        </View>

        {/* Widthrawal modal */}
        <ModalBrand
          title={"Withdrawal"}
          onrequestclose={widthrawal.hideModal}
          visible={widthrawal.isVissible}
          content={
            <View className="">
              <InputBrand
                value={withdrawalAmount}
                type={"number"}
                placeholder={"Enter amount"}
                onchange={(text) => setwithdrawalAmount(text)}
              />
              <View>
                <ButtonBrand
                  text={"Withdrawal"}
                  fxn={withdraw}
                  disabled={isValid()}
                />
              </View>
            </View>
          }
        />

        {/* profile modal */}
        <ModalBrand
          title="Update Profile"
          visible={profileModal.isVissible}
          onrequestclose={profileModal.hideModal}
          content={
            <View>
              <Text className="text-gray-600 text-lg ml-2 mb-2">
                First Name
              </Text>
              <InputBrand
                value={userData.firstName}
                onchange={(text) => updateUserData("firstName", text)}
                placeholder={"First Name"}
                type={"text"}
              />
              <Text className="text-gray-600 text-lg ml-2 mb-2">Last Name</Text>
              <InputBrand
                value={userData.lastName}
                onchange={(text) => updateUserData("lastName", text)}
                placeholder={"Last Name"}
                type={"text"}
              />
              <Text className="text-gray-600 text-lg ml-2 mb-2">Email</Text>
              <InputBrand
                value={userData.email}
                onchange={(text) => updateUserData("email", text)}
                placeholder={"Email"}
                type={"email"}
              />
              <Text className="text-gray-600 text-lg ml-2 mb-2">
                Phone Number
              </Text>
              <InputBrand
                value={userData.phone}
                onchange={(text) => updateUserData("phone", text)}
                placeholder={"Phone Number"}
                type={"number"}
              />
              <View>
                {isLoading ? (
                  <ActivityIndicator size="large" color="#8f08fdde" />
                ) : (
                  <ButtonBrand
                    text={"Update"}
                    fxn={() => {
                      updateUserInfo();
                    }}
                    disabled={isFormValid() || isLoading}
                  />
                )}
              </View>
            </View>
          }
        />
      </ScrollView>
    </SafeAreaView>
  );
};

export default Profile;

const styles = StyleSheet.create({});
