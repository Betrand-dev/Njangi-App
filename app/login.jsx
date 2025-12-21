import ButtonBrand from "@/components/ButtonBrand";
import InputBrand from "@/components/InputBrand";
import { router } from "expo-router";
import { useContext, useState } from "react";
import {
  ActivityIndicator,
  Alert,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  Text,
  TouchableOpacity,
  View,
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { AuthContext } from "./contexts/AuthContext";

const LoginScreen = () => {
  // formdata usecase
  const [formData, setFormData] = useState({
    email: "",
    password: "",
  });
  const [loading, setLoading] = useState(false);

  // auth context (hooks must be called at top level)
  const auth = useContext(AuthContext);

  const handleLogin = async () => {
    setLoading(true);
    try {
      await auth.login(formData.email, formData.password);
      router.push("/home");
    } catch (err) {
      console.log(err?.response?.data || err.message);
      Alert.alert(
        "Login Failed",
        err?.response?.data?.message || "Login failed"
      );
    } finally {
      setLoading(false);
    }
  };

  const isFormValid = () => {
    // destructuring email and password from formData
    const { email, password } = formData;

    // basic validation
    if (email.trim() !== "" && password.trim() !== "") {
      return false;
    }

    return true;
  };

  // formdata update
  const updateFormData = (field, value) => {
    setFormData((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  return (
    <SafeAreaView className="flex-1 bg-background px-4 pt-4 justify-between">
      <KeyboardAvoidingView
        behavior={Platform.OS === "ios" ? "padding" : "height"}
      >
        <ScrollView showsVerticalScrollIndicator={false}>
          <View>
            {/* Header */}
            <View className="mb-8">
              <Text className="text-2xl font-bold text-gray-900 mb-2">
                Hey, Welcome back!
              </Text>
              <Text className="text-base text-gray-600">
                Login To manage your njangi transactions
              </Text>
            </View>

            {/* Form */}
            <View className="mt-24">
              <Text className="ml-2 mb-2 font-bold text-gray-600 text-lg">
                Email
              </Text>
              <InputBrand
                value={formData.email}
                onchange={(text) => updateFormData("email", text)}
                placeholder={"Email"}
                type={"email"}
              />
              <Text className="ml-2 mb-2 font-bold text-gray-600 text-lg">
                Password
              </Text>
              <InputBrand
                value={formData.password}
                onchange={(text) => updateFormData("password", text)}
                placeholder={"Password"}
                type="password"
              />
            </View>
          </View>
        </ScrollView>
      </KeyboardAvoidingView>

      <View className="bottom-4">
        {loading ? (
          <ActivityIndicator size="large" color="#8f08fdde" />
        ) : (
          <ButtonBrand
            text="login"
            fxn={handleLogin}
            disabled={isFormValid() || loading}
          />
        )}
        <TouchableOpacity
          className="mt-4"
          onPress={() => router.push("/signup")}
        >
          <Text className="underline text-center font-semibold text-primary">
            Don't have an account? Sign up
          </Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
};

export default LoginScreen;
