import { router } from "expo-router";
import React, { useState } from "react";
import { SafeAreaView, SafeAreaProvider  } from "react-native-safe-area-context";
import {
  KeyboardAvoidingView,
  Platform,
  StyleSheet,
  TextInput,
  TouchableOpacity,
  View,
  ScrollView,
} from "react-native";
import { Text } from "react-native-paper";
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
    <SafeAreaProvider>
      <SafeAreaView style={styles.container}>
    <KeyboardAvoidingView
      behavior={Platform.OS === "ios" ? "padding" : "height"}
    >
      <Text variant="headlineMedium" style={styles.title}>
        Welcome Back
      </Text>
      <Text style={styles.subtitle}>
        Sign in to manage your njangi contribution groups
      </Text>

      <View style={styles.inputfield}>
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
    </SafeAreaProvider>
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
