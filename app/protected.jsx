import { router } from "expo-router";
import { useContext, useEffect, useState } from "react";
import { ActivityIndicator, Text, TouchableOpacity, View } from "react-native";
import { AuthContext } from "./contexts/AuthContext";
import useRequireAuth from "../hooks/useRequireAuth";
import api from "./services/api";

const ProtectedScreen = () => {
  const { user, logout } = useContext(AuthContext);
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchProtected = async () => {
      try {
        const res = await api.get("/protected");
        setData(res.data);
      } catch (err) {
        console.log(
          "Protected fetch error",
          err?.response?.data || err.message
        );
        // if token refresh failed upstream, logout and go to login
        try {
          await logout();
        } catch (e) {}
        router.replace("/login");
      } finally {
        setLoading(false);
      }
    };
    fetchProtected();
  }, []);

  // enforce auth; this will redirect to /login if not authenticated
  useRequireAuth();

  if (loading)
    return (
      <View className="flex-1 justify-center items-center">
        <ActivityIndicator />
      </View>
    );

  return (
    <View className="flex-1 p-4">
      <Text className="text-lg font-bold mb-4">Protected data</Text>
      <Text className="mb-6">{JSON.stringify(data)}</Text>
      <TouchableOpacity
        className="bg-red-500 rounded-full px-4 py-3"
        onPress={async () => {
          await logout();
          router.replace("/login");
        }}
      >
        <Text className="text-white text-center font-semibold">Logout</Text>
      </TouchableOpacity>
    </View>
  );
};

export default ProtectedScreen;
