import AsyncStorage from "@react-native-async-storage/async-storage";
import axios from "axios";
import { router } from "expo-router";
import { createContext, useEffect, useState } from "react";
import api, { BASE_URL, clearTokens, saveTokens } from "../services/api";

export const AuthContext = createContext({});

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // load token on mount
    const load = async () => {
      try {
        const access = await AsyncStorage.getItem("access_token");
        const refresh = await AsyncStorage.getItem("refresh_token");
        if (access) {
          // attempt to fetch current user profile from backend
          try {
            const profileRes = await api.get("/auth/me");
            setUser({ access, refresh, profile: profileRes.data });
          } catch (e) {
            // if fetching profile fails, still set basic token info
            setUser({ access, refresh });
          }
        }
      } catch (e) {
        console.warn("Auth load error", e);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, []);

  const login = async (email, password) => {
    const res = await api.post("/auth/login", { email, password });
    const { access_token, refresh_token } = res.data;
    await saveTokens({ access: access_token, refresh: refresh_token });
    // fetch user profile and set full user object
    try {
      const profile = await api.get("/auth/me");
      setUser({
        email,
        access: access_token,
        refresh: refresh_token,
        profile: profile.data,
      });
    } catch (e) {
      setUser({ email, access: access_token, refresh: refresh_token });
    }
    return res;
  };

  const refreshUser = async () => {
    try {
      const profile = await api.get("/auth/me");
      // merge into existing user state
      setUser((prev) => ({ ...(prev || {}), profile: profile.data }));
      return profile.data;
    } catch (e) {
      console.warn("Failed to refresh user", e?.message || e);
      return null;
    }
  };

  const signup = async (payload) => {
    const res = await api.post("/auth/register", payload);
    return res;
  };

  const logout = async () => {
    try {
      const refresh = await AsyncStorage.getItem("refresh_token");
      if (refresh) {
        // try to revoke refresh token on server
        await axios.post(
          `${BASE_URL}/auth/logout_refresh`,
          {},
          { headers: { Authorization: `Bearer ${refresh}` } }
        );
      }
    } catch (e) {
      // ignore errors - proceed to clear tokens locally
      console.warn("Error revoking refresh token", e?.message || e);
    }
    await clearTokens();
    setUser(null);
    // Navigate to login screen
    router.replace("/login");
  };

  return (
    <AuthContext.Provider
      value={{ user, loading, login, signup, logout, refreshUser }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export default AuthContext;
