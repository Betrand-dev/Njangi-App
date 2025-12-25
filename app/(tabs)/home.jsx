import { Bell, Eye, EyeOffIcon, PlusCircleIcon, PiggyBank, Receipt, ArrowLeftRight, PlusIcon } from "lucide-react-native";
import React, { useState, useEffect } from "react";
import {
  ActivityIndicator,
  Alert,
  Pressable,
  ScrollView,
  Text,
  TouchableOpacity,
  View,
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import ModalBrand from "../../components/ModalBrand";
import useModal from "../../hooks/useModal";
import useRequireAuth from "../../hooks/useRequireAuth";
import { router } from "expo-router";
import InputBrand from "../../components/InputBrand";
import ButtonBrand from "../../components/ButtonBrand";
import api from "../services/api";

export default function WalletScreen() {
  const [view, setView] = React.useState(false);
  const [isLoading, setIsLoading] = React.useState(true);
  const { user, loading } = useRequireAuth();
  const showNotification = useModal();
  const depositModal = useModal();
  const [depositAmount, setDepositAmount] = useState("")
  const load = () => {
    if (isLoading) {
      Alert.alert("trying", "chia what am i doiing", [
        { text: "Cancel", style: "cancel" },
        { text: "discard", onPress: () => setIsLoading(!isLoading) },
      ]);
    } else {
      alert("did not work");
      setIsLoading(!isLoading);
    }
  };

  useEffect(() => {
    loading
  }, [user])

  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'XAF',
    }).format(amount);
  };

  const isValid = () => {
    return depositAmount.trim() == "";
  }

  const deposit = async () => {
    const data = {
      depositAmount
    }
    try{
      const response = await api.post("/deposit", data)
      Alert.alert("Deposit", "Successfull Deposit", [
            {
              text: "Cancel",
              style: "cancel",
            },
            {
              text: "Go Back",
              style: "destructive",
              onPress: router.push("/home"),
            },
          ]);
    }catch(error) {
      Alert.alert("error", "Failed to deposit");
      console.error("deposit failed " + error);
    }
  }

  return (
    // while auth status is being determined, show a spinner
    loading ? (
      <SafeAreaView className="flex-1 bg-background justify-center items-center">
        <ActivityIndicator />
      </SafeAreaView>
    ) : (
      <SafeAreaView className="flex-1 bg-background">
        {/* Header */}
        <View className="flex-row items-center   pt-8 pb-5 px-3 border-b border-gray-200  justify-between">
          <View className="flex-row items-center space-x-2">
            <View className="w-10 h-10 bg-gray-200 rounded-full flex items-center justify-center">
              <Text className="font-bold text-gray-700">
                {(user?.profile?.firstName?.[0] || "A") +
                  (user?.profile?.lastName?.[0] || "B")}
              </Text>
            </View>
            <Text className="ml-2 text-lg font-semibold">
              Hello{" "}
              <Text className="text-black">
                {user?.profile?.firstName || user?.profile?.email || "User"}
              </Text>{" "}
              👋
            </Text>
          </View>
          <TouchableOpacity onPress={showNotification.showModal}>
            <Bell className="text-primary" color="#8f08fdde" />
          </TouchableOpacity>
        </View>
        <ScrollView
          showsVerticalScrollIndicator={false}
          className="px-4 pt-2 space-y-6"
        >
          {/* transaction  */}
          <View className="bg-gray-100 flex flex-row justify-between items-center rounded-2xl px-4 py-4">
            <Text className="text-gray-500  font-bold">
              Balance
            </Text>
            <View className="flex-row justify-center items-center mt-1">
              {/* <Text className="text-gray-800 font-semibold mr-2">XAF</Text> */}
              <Text className="text-2xl font-bold tracking-widest">
                {view ? formatCurrency(user?.profile?.balance) : "******"}
              </Text>
              <Pressable className="ml-2" onPress={() => setView(!view)}>
                {view ? (
                  <Eye size={18} color="gray" />
                ) : (
                  <EyeOffIcon size={18} color="gray" />
                )}
              </Pressable>
            </View>
            <TouchableOpacity className="bg-primary/10 p-3 rounded-3xl flex flex-row justify-center items-center"
            onPress={depositModal.showModal}
            >
              <PlusIcon color={"#8f08fdde"} size={16}/>
              <Text className="text-primary font-medium">Deposit</Text>
            </TouchableOpacity>
          </View>

          {/* tryers */}
          <View className="mt-3 flex flex-row justify-between items-center gap-1">
            {/* personal savings */}
            <TouchableOpacity className="flex flex-col w-1/2 px-8 py-4 justify-center items-center border rounded-lg border-gray-300"
            onPress={() => router.push("/PersonalSavings")}
            >
              <PiggyBank className="text-primary" color="#8f08fdde" />
              <View className="mt-3 flex justify-center items-center">
                <Text className="items-center font-light">Personal Savings</Text>
              </View>
            </TouchableOpacity>
            {/* Expense tracking */}
             <TouchableOpacity className="flex flex-col px-8 py-4 w-1/2 justify-center items-center border rounded-lg border-gray-300"
             onPress={() => router.push("/ExpenseTracking")}
             >
              <Receipt className="text-primary" color="#8f08fdde" />
              <View className="mt-3 flex justify-center items-center">
                <Text className="items-center font-light">Expense Tracking</Text>
              </View>
            </TouchableOpacity>
          </View>
          {/* transactions */}
          <View className="mt-4">
            <TouchableOpacity className="flex flex-col px-4 py-6 w-full justify-center items-center border rounded-lg border-gray-300">
              <ArrowLeftRight className="text-primary" color="#8f08fdde" />
              <View className="mt-3 flex justify-center items-center">
                <Text className="items-center font-light">Transactions</Text>
              </View>
            </TouchableOpacity>
          </View>

          {/* Transaction history */}
          <View className="mt-10">
            <Text className="font-extrabold text-gray-600 text-xl">Transaction History</Text>
            {/* Show atleast 3 recent transactions */}
            <View className="flex justify-center items-center pt-20">
              <ArrowLeftRight className="text-primary" color="#d1d5db" />
              <Text className="text-xl text-gray-300">No-Transactions-Yet..</Text>
            </View>
          </View>

          {/* notification Modal */}
          <ModalBrand
            title="Notification"
            visible={showNotification.isVissible}
            onrequestclose={showNotification.hideModal}
            content={
              <View className="self-center mt-4">
                <Text>Notificationn</Text>
              </View>
            }
          />

          {/* deposit modal */}
          <ModalBrand
            title="Deposit"
            visible={depositModal.isVissible}
            onrequestclose={depositModal.hideModal}
            content={
              <View className="">
                <InputBrand 
                value={depositAmount}
                type={"number"}
                placeholder={"Enter amount"}
                onchange={(text) => setDepositAmount(text)}
                />
                <View>
                  <ButtonBrand text={"Deposit"} fxn={deposit} disabled={isValid()}/>
                </View>
              </View>
            }
          />
        </ScrollView>
      </SafeAreaView>
    )
  );
}
