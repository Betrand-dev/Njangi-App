import { Ionicons, MaterialIcons } from "@expo/vector-icons";
import { Tabs } from "expo-router";
// import AppTheme from "../config/theme";
import useRequireAuth from "../../hooks/useRequireAuth";
import { SafeAreaView } from "react-native-safe-area-context";
import { ActivityIndicator } from "react-native";


 function TabLayout() {
  const { user, loading } = useRequireAuth();

  return (
    loading ? (
          <SafeAreaView className="flex-1 bg-background justify-center items-center">
            <ActivityIndicator />
          </SafeAreaView>
        ) :(
        <Tabs
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: "#8f08fdde",
      }}
    >
      <Tabs.Screen
        name="home"
        options={{
          title: "Home",
          tabBarIcon: ({ color, size }) => (
            <Ionicons name="home" color={color} size={size} />
          ),
        }}
      />
      <Tabs.Screen
        name="groups"
        options={{
          title: "Groups",
          tabBarIcon: ({ color, size }) => (
            <MaterialIcons name="groups" color={color} size={size} />
          ),
        }}
      />
      <Tabs.Screen
        name="profile"
        options={{
          title: "Profile",
          tabBarIcon: ({ color, size }) => (
            <Ionicons name="person-circle" color={color} size={size} />
          ),
        }}
      />
    </Tabs>
    )
  );
}

export default TabLayout;
