import { router } from "expo-router";
import React, { useState } from "react";
import { SafeAreaView, SafeAreaProvider  } from "react-native-safe-area-context";
import {
  KeyboardAvoidingView,
  Platform,
  StyleSheet,
  TouchableOpacity,
  View,
  TextInput,
  ScrollView
} from "react-native";
import { Ionicons} from "@expo/vector-icons";
import { StatusBar } from "react-native";
import { Button, Text } from "react-native-paper";
import { AppTheme } from "./config/theme";
import ButtonBrand from "@/components/ButtonBrand";

export default function SignupScreen() {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");

  const handleSignup = () => {
    // later: call your Flask backend or Firebase auth
    console.log("creating account with", email, password);
    router.push("/home");
  };

  return (
    <>
    <StatusBar barStyle="light-content" backgroundColor="black" translucent />
    <SafeAreaView style={styles.container}>
        <View style={styles.header}>
        <Text variant="headlineMedium">
        <Ionicons style={{marginRight: 8}} name="arrow-back" size={30} color={AppTheme.colors.primary} onPress={() => router.push("/login")}/>
        <Text style={styles.title}>Create Account</Text>
      </Text>
      </View>
    <KeyboardAvoidingView
      behavior={Platform.OS === "ios" ? "padding" : "height"}
      style = {{paddingLeft: 20, paddingRight: 20}}
    >
      
      <ScrollView>
      <Text style={styles.subtitle}>Join and manage your contributions</Text>
      <View style={styles.inputfield}>
        <Text style={styles.label}>Full Name</Text>
        <TextInput
          value={name}
          onChange={setName}
          style={styles.input}
          placeholder="John deo"
        />

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

        <Text style={styles.label}>Confirm Password</Text>
        <TextInput
          secureTextEntry
          value={confirmPassword}
          onChange={setConfirmPassword}
          style={styles.input}
          placeholder="Confirm password"
        />

      </View>
      </ScrollView>

      <View style={{marginTop: 50}}>
        <ButtonBrand text="Sign up" fxn={handleSignup}/>
      </View>

      <TouchableOpacity onPress={() => router.push("/login")}>
        <Text style={styles.link}>Already have an account? Login</Text>
      </TouchableOpacity>
    </KeyboardAvoidingView>
    </SafeAreaView>
    </>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    // paddingLeft: 20,
    // paddingRight: 20,
    backgroundColor: AppTheme.colors.background,
  },
  header:{
    // display: "flex",
    // justifyContent: "center",
    marginBottom: 20,
    marginTop: 50,
    paddingLeft: 10,
    // paddingRight: 20,
    borderRadius: 20,
    // backgroundColor: "#f0f0f0",
  },
  title: {
    fontWeight: "bold",
    color: AppTheme.colors.primary,
    paddingLeft: 50,
    // alignSelf: "center",
  },
  subtitle: {
    color: "#666",
    marginBottom: 25,
    // alignSelf: "center"
  },
  label: {
    paddingRight: 20,
    fontWeight: "bold",
    fontSize: 16,
    marginBottom: 10,
    color: "#686565ff",
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
  button: {
    paddingVertical: 5,
    borderRadius: 10,
    marginTop: 10,
  },
  link: {
    color: AppTheme.colors.primary,
    marginTop: 15,
    textAlign: "center",
    fontWeight: "650",
    textDecorationLine: "underline",
  },
});
