import { router } from "expo-router";
import React, { useState } from "react";
import {
  KeyboardAvoidingView,
  Platform,
  StyleSheet,
  TouchableOpacity,
  View,
} from "react-native";
import { TextInput, Button, Text, Card} from "react-native-paper";
import { AppTheme } from "./config/theme"

export default function SignupScreen() {
  const [name , setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");

  const handleSignup = () => {
    // later: call your Flask backend or Firebase auth
    console.log("Logging in with", email, password);
    router.push("/home");
  };

  return (
    <KeyboardAvoidingView behavior={Platform.OS === "ios" ? "padding" : "height"} style={styles.container}>
      <Card style={styles.card}>
        <Card.Content>
          <Text variant="headlineMedium" style={styles.title}>Create Account</Text>
          <Text style={styles.subtitle}>Join and manage your contributions</Text>
          <TextInput
          label="Full Name"
          mode="outlined"
          left={<TextInput.Icon icon="account-outline"/>}
          value={name}
          onChangeText={setName}
          style={styles.input}
          />
          <TextInput
          label="Email"
          mode="outlined"
          left={<TextInput.Icon icon="email-outline"/>}
          value={email}
          onChangeText={setEmail}
          style={styles.input}
          />
          <TextInput
          label="Password"
          mode="outlined"
          secureTextEntry
          left={<TextInput.Icon icon="lock-outline"/>}
          value={password}
          onChangeText={setPassword}
          style={styles.input}
          />
          <TextInput
          label="Confirm Password"
          mode="outlined"
          secureTextEntry
          left={<TextInput.Icon icon="lock-check-outline"/>}
          value={confirmPassword}
          onChangeText={setConfirmPassword}
          style={styles.input}
          />
          <Button
          mode="contained"
          onPress={handleSignup}
          style={styles.button}
          buttonColor={AppTheme.colors.primary}
          >
            Sign Up
          </Button>
          <TouchableOpacity
          onPress={() =>  router.push("/login")}
          >
            <Text style={styles.link}>Already have an account? Login</Text>
          </TouchableOpacity>
        </Card.Content>
      </Card>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    padding: 20,
    backgroundColor: AppTheme.colors.background,
  },
  card: {
    borderRadius: 20,
    padding: 20,
    backgroundColor: "#fff",
    elevation: 4,
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
  input: {
    marginBottom: 15,
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
    fontWeight: "600",
  },
});
