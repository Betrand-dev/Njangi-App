import ButtonBrand from "@/components/ButtonBrand";
import InputBrand from "@/components/InputBrand";
import { router } from "expo-router";
import React, { useRef, useState } from "react";
import {
  ActivityIndicator,
  Alert,
  Dimensions,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  Text,
  TouchableOpacity,
  View,
} from "react-native";
import { FlatList } from "react-native-gesture-handler";
import { SafeAreaView } from "react-native-safe-area-context";

const { width } = Dimensions.get("window");

const SignupScreen = () => {
  const [currentStep, setCurrentStep] = useState(0);
  const [loading, setLoading] = useState(false);
  const [formData, setFormData] = useState({
    firstName: "",
    lastName: "",
    email: "",
    phone: "",
    password: "",
    confirmPassword: "",
  });
  const scrollViewRef = useRef(null);
  const getItemLayout = (_, index) => ({
    length: width,
    offset: width * index,
    index,
  });

  const steps = [
    {
      id: "1",
      title: "Personal Info",
      label1: "First Name",
      label2: "Last Name",
      inputType1: "text",
      inputType2: "text",
      placeholder1: "John",
      placeholder2: "Deo",
      field1: "firstName",
      field2: "lastName",
      value1: formData.firstName,
      value2: formData.lastName,
    },
    {
      id: "2",
      title: "Contacts",
      label1: "Email",
      label2: "Phone",
      inputType1: "text",
      inputType2: "number",
      placeholder1: "john@gmail.com",
      placeholder2: "650537134",
      field1: "email",
      field2: "phone",
      value1: formData.email,
      value2: formData.phone,
    },
    {
      id: "3",
      title: "Sucurity",
      label1: "Password",
      label2: "Comfirm Password",
      inputType1: "password",
      inputType2: "password",
      placeholder1: ".......",
      placeholder2: ".......",
      field1: "password",
      field2: "confirmPassword",
      value1: formData.password,
      value2: formData.confirmPassword,
    },
  ];

  // update the form data
  const updateFormData = (field, value) => {
    setFormData((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  const progress = (currentStep / steps.length) * 100;

  const handleNext = () => {
    if (currentStep < steps.length - 1) {
      scrollViewRef.current.scrollToIndex({
        index: currentStep + 1,
        animated: true,
      });
    } else {
      handleSignUp();
    }
  };

  const handleScroll = (event) => {
    const index = Math.round(event.nativeEvent.contentOffset.x / width);
    setCurrentStep(index);
  };

  const handleSignUp = async () => {
    setLoading(true);
    try {
      // try to register via backend
      const { signup } = await import("./contexts/AuthContext").then((m) => m);
      // lazy useContext would require component-level, so call api directly via services instead
      const apiModule = await import("./services/api");
      await apiModule.default.post("/auth/register", {
        firstName: formData.firstName,
        lastName: formData.lastName,
        email: formData.email,
        phone: formData.phone,
        password: formData.password,
      });
      Alert.alert("Success", "Account created");
      router.push("/login");
    } catch (err) {
      console.log(err?.response?.data || err.message);
      Alert.alert(
        "Signup Failed",
        err?.response?.data?.message || "Signup failed"
      );
    } finally {
      setLoading(false);
    }
  };

  const validStep = () => {
    const field1 = steps[currentStep].value1;
    const field2 = steps[currentStep].value2;
    if (field1 == "" && field2 == "") {
      return true;
    } else if (field1 != "" && field2 == "") {
      return true;
    } else if (field1 == "" && field2 != "") {
      return true;
    } else {
      return false;
    }
  };

  return (
    <SafeAreaView className="flex-1 px-4 justify-between  bg-background">
      <KeyboardAvoidingView
        behavior={Platform.OS === "ios" ? "padding" : "height"}
        className=""
      >
        {/* header */}
        <View>
          <Text className="font-bold  text-2xl  text-primary">
            Create Account
          </Text>
          <Text className="text-base text-gray-600">
            Login To manage your njangi transactions
          </Text>
          {/* progress bar */}
          <View className="w-full mt-4  self-center  h-1 rounded-full bg-gray-300">
            <View
              className="h-1 bg-primary rounded-full"
              style={{ width: `${progress}%` }}
            ></View>
          </View>
        </View>
        <ScrollView>
          <FlatList
            ref={scrollViewRef}
            data={steps}
            horizontal
            pagingEnabled
            scrollEnabled={false}
            showsHorizontalScrollIndicator={false}
            keyExtractor={(item) => item.id}
            getItemLayout={getItemLayout}
            onScroll={handleScroll}
            scrollEventThrottle={16}
            renderItem={({ item }) => (
              <View className="w-screen flex-1  pt-6">
                {/* title */}
                <Text className="mb-4 font-semibold text-2xl text-primary">
                  {item.title}
                </Text>
                {/* first label */}
                <View className="p-6">
                  <Text className="ml-2 mb-2 font-bold text-gray-600 text-lg">
                    {item.label1}
                  </Text>
                  {/* first input field */}
                  <View className="w-80">
                    <InputBrand
                      value={item.value1}
                      onchange={(text) => updateFormData(item.field1, text)}
                      placeholder={item.placeholder1}
                      type={item.inputType1}
                    />
                  </View>
                  {/* second label */}
                  <Text className="ml-2 mb-2 font-bold text-gray-600 text-lg">
                    {item.label2}
                  </Text>
                  {/* second input field */}
                  <View className="w-80">
                    <InputBrand
                      value={item.value2}
                      onchange={(text) => updateFormData(item.field2, text)}
                      placeholder={item.placeholder2}
                      type={item.inputType2}
                    />
                  </View>
                </View>
              </View>
            )}
          />
        </ScrollView>
      </KeyboardAvoidingView>
      <View className="bottom-4">
        {loading ? (
          <ActivityIndicator size="large" color="#8f08fdde" />
        ) : (
          <ButtonBrand
            text={currentStep === steps.length - 1 ? "Create Account" : "Next"}
            fxn={handleNext}
            disabled={validStep() || loading}
          />
        )}
        <TouchableOpacity
          className="mt-4"
          onPress={() => router.push("/login")}
        >
          <Text className="underline text-center font-semibold text-primary">
            Already have an account? Log in
          </Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
};

export default SignupScreen;
