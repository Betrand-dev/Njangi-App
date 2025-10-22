import { Stack } from "expo-router";
import { GestureHandlerRootView } from "react-native-gesture-handler";
import './globals.css';
import { StatusBar } from "react-native";

export default function RootLayout() {
  return (
  <>
  <StatusBar barStyle="light-content" backgroundColor="black" translucent />
  <GestureHandlerRootView style = {{flex: 1}}>
    <Stack screenOptions={{headerShown: false}}>
    <Stack.Screen name="index"/>
    <Stack.Screen name="login"/>
    <Stack.Screen name="signup"/>
    <Stack.Screen name="(tabs)"/>
    <Stack.Screen name="tryer"/>
  </Stack>
  </GestureHandlerRootView>
  </>
  );
}
