import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  ScrollView,
  Alert,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';

const LoginScreen = () => {
  const [loginMethod, setLoginMethod] = useState('phone'); // 'phone' or 'username'
  const [formData, setFormData] = useState({
    phoneNumber: '',
    username: '',
    password: '',
  });
  const [showPassword, setShowPassword] = useState(false);

  const handleLogin = () => {
    const { phoneNumber, username, password } = formData;
    
    if (!password.trim()) {
      Alert.alert('Error', 'Please enter your password');
      return;
    }

    if (loginMethod === 'phone' && !phoneNumber.trim()) {
      Alert.alert('Error', 'Please enter your phone number');
      return;
    }

    if (loginMethod === 'username' && !username.trim()) {
      Alert.alert('Error', 'Please enter your username');
      return;
    }

    // Simulate login process
    Alert.alert('Success', 'Login successful!', [
      { text: 'OK', onPress: () => console.log('Navigate to home screen') }
    ]);
  };

  const isFormValid = () => {
    const { phoneNumber, username, password } = formData;
    
    if (!password.trim()) return false;
    
    if (loginMethod === 'phone') {
      return phoneNumber.trim().length > 0;
    } else {
      return username.trim().length > 0;
    }
  };

  const updateFormData = (field, value) => {
    setFormData(prev => ({
      ...prev,
      [field]: value
    }));
  };

  return (
    <KeyboardAvoidingView 
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      className="flex-1 bg-white"
    >
      <ScrollView 
        className="flex-1"
        contentContainerStyle={{ flexGrow: 1 }}
        showsVerticalScrollIndicator={false}
      >
        <View className="flex-1 px-6 pt-6">
          {/* Header */}
          <View className="mb-8">
            <Text className="text-2xl font-bold text-gray-900 mb-2">
              Hey, Welcome back!
            </Text>
            <Text className="text-base text-gray-600">
              Choose your preferred option to sign in to your Ejara account.
            </Text>
          </View>

          {/* Login Method Selection */}
          <View className="flex-row bg-gray-100 rounded-lg p-1 mb-6">
            <TouchableOpacity
              className={`flex-1 py-3 rounded-md ${
                loginMethod === 'phone' ? 'bg-white shadow-sm' : ''
              }`}
              onPress={() => setLoginMethod('phone')}
            >
              <Text 
                className={`text-center font-medium ${
                  loginMethod === 'phone' ? 'text-blue-600' : 'text-gray-600'
                }`}
              >
                Use a phone number
              </Text>
            </TouchableOpacity>
            <TouchableOpacity
              className={`flex-1 py-3 rounded-md ${
                loginMethod === 'username' ? 'bg-white shadow-sm' : ''
              }`}
              onPress={() => setLoginMethod('username')}
            >
              <Text 
                className={`text-center font-medium ${
                  loginMethod === 'username' ? 'text-blue-600' : 'text-gray-600'
                }`}
              >
                Use a username
              </Text>
            </TouchableOpacity>
          </View>

          {/* Form */}
          <View className="flex-1">
            {/* Phone Number/Username Input */}
            <View className="mb-4">
              <Text className="text-sm font-medium text-gray-700 mb-2">
                {loginMethod === 'phone' ? 'Your phone number' : 'Your username'}
              </Text>
              
              {loginMethod === 'phone' ? (
                <View className="flex-row items-center border border-gray-300 rounded-lg px-3 py-4 bg-white">
                  <View className="flex-row items-center mr-3">
                    <Text className="text-gray-700 text-base">+237</Text>
                    <Text className="text-gray-400 ml-1">▼</Text>
                  </View>
                  <TextInput
                    className="flex-1 text-base text-gray-800"
                    placeholder="e.g., 6 98 09 45 78"
                    placeholderTextColor="#9CA3AF"
                    value={formData.phoneNumber}
                    onChangeText={(text) => updateFormData('phoneNumber', text)}
                    keyboardType="phone-pad"
                  />
                </View>
              ) : (
                <TextInput
                  className="border border-gray-300 rounded-lg px-4 py-4 text-base text-gray-800 bg-white"
                  placeholder="Enter your username"
                  placeholderTextColor="#9CA3AF"
                  value={formData.username}
                  onChangeText={(text) => updateFormData('username', text)}
                  autoCapitalize="none"
                />
              )}
            </View>

            {/* Password Input */}
            <View className="mb-4">
              <Text className="text-sm font-medium text-gray-700 mb-2">
                Your password
              </Text>
              <View className="relative">
                <TextInput
                  className="border border-gray-300 rounded-lg px-4 py-4 text-base text-gray-800 bg-white pr-16"
                  placeholder="Enter your password"
                  placeholderTextColor="#9CA3AF"
                  value={formData.password}
                  onChangeText={(text) => updateFormData('password', text)}
                  secureTextEntry={!showPassword}
                />
                <TouchableOpacity
                  className="absolute right-4 top-4"
                  onPress={() => setShowPassword(!showPassword)}
                >
                  <Text className="text-blue-500 text-sm font-medium">
                    {showPassword ? 'Hide' : 'Show'}
                  </Text>
                </TouchableOpacity>
              </View>
            </View>

            {/* Forgot Password */}
            <TouchableOpacity className="mb-6">
              <Text className="text-blue-500 text-sm font-medium">
                Did you forget your password?
              </Text>
            </TouchableOpacity>

            {/* Divider */}
            <View className="flex-row items-center mb-6">
              <View className="flex-1 h-px bg-gray-300" />
            </View>
          </View>

          {/* Bottom Section */}
          <View className="pb-8">
            <TouchableOpacity
              className={`py-4 rounded-lg ${
                isFormValid() ? 'bg-blue-500' : 'bg-blue-300'
              }`}
              onPress={handleLogin}
              disabled={!isFormValid()}
            >
              <Text className="text-white text-center font-semibold text-base">
                Sign in
              </Text>
            </TouchableOpacity>

            <View className="flex-row justify-center mt-4">
              <Text className="text-gray-600 text-base">
                Don't have an account?{' '}
              </Text>
              <TouchableOpacity>
                <Text className="text-blue-500 text-base font-medium">
                  Create an account
                </Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
};

export default LoginScreen;