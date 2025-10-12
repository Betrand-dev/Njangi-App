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

export default function LoginScreen() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const handleLogin = () => {
    // later: call your Flask backend or Firebase auth
    console.log("Logging in with", email, password);
    router.push("/home");
  };

  return (
    <KeyboardAvoidingView behavior={Platform.OS === "ios" ? "padding" : "height"} style={styles.container}>
      <Card style={styles.card}>
        <Card.Content>
          <Text variant="headlineMedium" style={styles.title}>Welcome Back</Text>
          <Text style={styles.subtitle}>Sign in to manage your njangi contribution groups</Text>
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
          <Button
          mode="contained"
          onPress={handleLogin}
          style={styles.button}
          buttonColor={AppTheme.colors.primary}
          >
            Login
          </Button>
          <TouchableOpacity
          onPress={() =>  router.push("/signup")}
          >
            <Text style={styles.link}>Dont't have an account? Sign up</Text>
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
