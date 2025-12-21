import { Stack } from "expo-router";
import { GestureHandlerRootView } from "react-native-gesture-handler";
import './globals.css';
import { AuthProvider } from "./contexts/AuthContext";
import { StatusBar } from "react-native";
import { NavigationContainer } from "@react-navigation/native";
import { createNativeStackNavigator } from "@react-navigation/native-stack";


export default function RootLayout() {
  return (
  <AuthProvider>
  <GestureHandlerRootView style = {{flex: 1}}>
    {/* <StatusBar barStyle="d" /> */}
    
    <Stack screenOptions={{headerShown: false}}>
    <Stack.Screen name="Index"/>
    <Stack.Screen name="login"/>
    <Stack.Screen name="signup"/>
    <Stack.Screen name="(tabs)"/>
    <Stack.Screen name="tryer"/>
  </Stack>
  </GestureHandlerRootView>
  </AuthProvider>
  );
}
