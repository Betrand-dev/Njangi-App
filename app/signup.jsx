import React, { useState,useRef } from "react";
import { KeyboardAvoidingView, Platform, ScrollView, Text, View, TouchableOpacity, Alert , Dimensions} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import InputBrand from "@/components/InputBrand";
import { FlatList } from "react-native-gesture-handler";
import ButtonBrand from "@/components/ButtonBrand";
import { router } from "expo-router";

const { width } = Dimensions.get("window");


const SignupScreen = () => {

  const [currentStep, setCurrentStep] = useState(0);
  const [formData, setFormData] = useState({
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
    password: '',
    confirmPassword: '',
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
  }
];

// update the form data
const updateFormData = (field, value) => {
    setFormData(prev => ({
      ...prev,
      [field]: value
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

  const handleSignUp = () => {
    // Validate passwords match on final step
    alert('Success', 'Account created successfully!', [
      { text: 'OK', onPress: () => console.log('Navigate to home screen') }
    ]);
    console.log(formData);
    router.push("/home");
  };


const validStep = () => {
    const field1 = steps[currentStep].value1;
    const field2 = steps[currentStep].value2;
    if (field1 == '' && field2 == ''){
    return true
  }else if(field1 != '' && field2 == ''){
    return true
  }
  else if(field1 == '' && field2 != ''){
    return true
  }else{
    return false
  }
  };


  return (
    <SafeAreaView className="flex-1 p-4  bg-background">
      <View className="w-72 self-center mt-3 h-1 rounded-full bg-gray-300">
        <View className="h-1 bg-primary rounded-full" style={{ width: `${progress}%` }}></View>
      </View>
      <View>
        <Text className="font-bold text-2xl p-4 text-primary">Create Account</Text>
      </View>
      <KeyboardAvoidingView
        behavior={Platform.OS === "ios" ? "padding" : "height"}
      >
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
                  <View className="w-screen flex-1 px-6 pt-6">
                <Text className="self-center font-semibold text-2xl text-primary">{item.title}</Text>
                <Text className="ml-2 mb-2 font-bold text-gray-600 text-lg">{item.label1}</Text>
                <InputBrand value={item.value1} onchange={(text) => updateFormData(item.field1, text)} placeholder={item.placeholder1} type={item.inputType1}/>
                <Text className="ml-2 mb-2 font-bold text-gray-600 text-lg">{item.label2}</Text>
                <InputBrand value={item.value2} onchange={(text) => updateFormData(item.field2, text)} placeholder={item.placeholder2} type={item.inputType2}/>
              </View>
                )}
          />
        </ScrollView>
      </KeyboardAvoidingView>
      <View className="p-4 mt-40">
                  <ButtonBrand text={currentStep === steps.length - 1 ? 'Create Account' : 'Next'} fxn={handleNext} disabled={validStep()} />
                  <TouchableOpacity className="mt-4" onPress={() => router.push("/login")}>
                          <Text className="underline text-center font-semibold text-primary">Already have an account? Log in</Text>
                        </TouchableOpacity>
            </View>
    </SafeAreaView>
  );
};

export default SignupScreen;
