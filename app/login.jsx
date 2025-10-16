import { router } from "expo-router";
import React, { useState } from "react";
import {
  KeyboardAvoidingView,
  Platform,
  StyleSheet,
  TextInput,
  TouchableOpacity,
  View,
  Text
} from "react-native";
import { SafeAreaProvider, SafeAreaView } from "react-native-safe-area-context";
import ButtonBrand from "../components/ButtonBrand";
import { AppTheme } from "./config/theme";

export default function LoginScreen() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const handleLogin = () => {
    // later: call your Flask backend or Firebase auth
    console.log("Logging in with", email, password);
    router.push("/home");
  };

  return (
    <SafeAreaView className="flex-1 p-4  bg-background">
    <KeyboardAvoidingView
      behavior={Platform.OS === "ios" ? "padding" : "height"}
    >
      <View className="p-4">
        <Text className="text-3xl font-bold text-primary mb-2">
        Welcome Back
      </Text>
      <Text className="text-base text-gray-600 text-lg">
        Sign in to manage your njangi contribution groups
      </Text>
      </View>

      <View className="mt-4 pl-8">
        <Text style={styles.label}>Email</Text>
        <TextInput
          value={email}
          onChange={setEmail}
          style={styles.input}
          placeholder="example@gmail.com"
        />
        <Text style={styles.label}>Password</Text>
        <TextInput
          secureTextEntry
          value={password}
          onChange={setPassword}
          style={styles.input}
          placeholder="password"
        />
      </View>

      <View style={{ marginTop: 250 }}>
        <ButtonBrand text="Login" fxn={handleLogin} />
      </View>

      <TouchableOpacity onPress={() => router.push("/signup")}>
        <Text style={styles.link}>Dont't have an account? Sign up</Text>
      </TouchableOpacity>
    </KeyboardAvoidingView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "flex-start",
    paddingLeft: 20,
    paddingRight: 20,
    paddingTop: 100,
    backgroundColor: AppTheme.colors.background,
  },
  label: {
    paddingRight: 20,
    fontWeight: "bold",
    fontSize: 16,
    marginBottom: 10,
    color: "#686565ff",
  },
  title: {
    fontWeight: "bold",
    color: AppTheme.colors.primary,
    marginBottom: 8,
  },
  subtitle: {
    color: "#666",
    marginBottom: 20,
  },
  inputfield: {
    marginTop: 20,
  },
  input: {
    marginBottom: 15,
    borderRadius: 30,
    borderWidth: 2,
    borderColor: "#ccc",
    borderRadius: 25,
    paddingVertical: 18,
    paddingHorizontal: 25,
    fontSize: 16,
    // paddingVertical: 5,
  },
  link: {
    color: AppTheme.colors.primary,
    marginTop: 15,
    textAlign: "center",
    fontWeight: "650",
    textDecorationLine: "underline",
  },
});
