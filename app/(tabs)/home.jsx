import { router } from "expo-router";
import {
  ArrowLeftRight,
  Bell,
  Eye,
  EyeOffIcon,
  PiggyBank,
  PlusIcon,
  Receipt,
  RefreshCwIcon,
} from "lucide-react-native";
import React, { useEffect, useState } from "react";
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
import ButtonBrand from "../../components/ButtonBrand";
import InputBrand from "../../components/InputBrand";
import ModalBrand from "../../components/ModalBrand";
import useModal from "../../hooks/useModal";
import useRequireAuth from "../../hooks/useRequireAuth";
import api from "../services/api";

export default function WalletScreen() {
  const [view, setView] = React.useState(false);
  const [isLoading, setIsLoading] = React.useState(true);
  const { user, loading } = useRequireAuth();
  const showNotification = useModal();
  const depositModal = useModal();
  const [depositAmount, setDepositAmount] = useState("");
  const [balanceLoading, setBalanceLoading] = useState(false);
  const [balance, setBalance] = useState([]);
  // NEW: State for notifications
  const [notifications, setNotifications] = useState([]);
  const [notificationsLoading, setNotificationsLoading] = useState(false);

  useEffect(() => {
    const getBalance = async () => {
      if (!user) return;
      setBalanceLoading(true);
      try {
        const response = await api.get("/deposit");
        setBalance(response.data.balance || []);
      } catch (error) {
        console.error("failed to get balance " + error);
      } finally {
        setBalanceLoading(false);
      }
    };
    getBalance();
  }, [user]);

  // NEW: Fetch notifications on mount
  useEffect(() => {
    const fetchNotifications = async () => {
      if (!user) return;
      setNotificationsLoading(true);
      try {
        const response = await api.get("/notifications");
        setNotifications(response.data.notifications || []);
      } catch (error) {
        console.error("Failed to fetch notifications:", error);
      } finally {
        setNotificationsLoading(false);
      }
    };
    fetchNotifications();
  }, [user]);

  const formatCurrency = (amount) => {
    return new Intl.NumberFormat("en-US", {
      style: "currency",
      currency: "XAF",
    }).format(amount);
  };

  const isValid = () => {
    return depositAmount.trim() == "";
  };

  const deposit = async () => {
    const data = {
      depositAmount,
    };
    try {
      const response = await api.post("/deposit", data);
      Alert.alert("Deposit", "Successfull Deposit", [
        {
          text: "Cancel",
          style: "cancel",
        },
        {
          text: "Go Back",
          style: "destructive",
          onPress: async () => {
            depositModal.hideModal();
            await refresh();
          },
        },
      ]);
    } catch (error) {
      Alert.alert("error", "Failed to deposit");
      console.error("deposit failed " + error);
    }
  };

  const refresh = async () => {
    if (!user) return;
    setBalanceLoading(true);
    try {
      const response = await api.get("/deposit");
      setBalance(response.data.balance || []);
    } catch (error) {
      console.error("failed to get balance " + error);
    } finally {
      setBalanceLoading(false);
    }
  };

  // NEW: Helper to format notification text
  const formatNotification = (notif) => {
    const type = notif.type;
    const payload = JSON.parse(notif.payload || "{}");
    let message = "";
    switch (type) {
      case "contribution_pending":
        message = ` Contribution Pending for ${notif.actor_name || "user"} in  group "${
          notif.group_name || "Unknown"
        }"`;
        break;
      case "contribution_confirmed":
        message = `Contribution confirmed for ${notif.actor_name || "user"} in  group "${
          notif.group_name || "Unknown"
        }"`;
        break;
      case "joined_group":
        message = `${notif.actor_name || "user"} joined  group "${
          notif.group_name || "Unknown"
        }"`;
        break;
      case "removed_from_group":
        message = `You were removed from a group "${
          notif.group_name || "Unknown"
        }"`;
        break;
      default:
        message = `Group activity: ${type} in "${
          notif.group_name || "Unknown"
        }"`;
    }
    return `${message} - ${new Date(notif.created_at).toLocaleDateString()}`;
  };

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
          <View className="flex-row items-center gap-1 space-x-3">
            <Pressable
              onPress={refresh}
              disabled={balanceLoading}
              className="mr-3"
            >
              <RefreshCwIcon
                className={`text-primary ${balanceLoading ? "opacity-50" : ""}`}
                color="#8f08fdde"
              />
            </Pressable>
            <TouchableOpacity onPress={showNotification.showModal}>
              <Bell className="text-primary" color="#8f08fdde" />
            </TouchableOpacity>
          </View>
        </View>
        <ScrollView
          showsVerticalScrollIndicator={false}
          className="px-4 pt-2 space-y-6"
        >
          {/* transaction  */}
          <View className="bg-gray-100 flex flex-row justify-between items-center rounded-2xl px-4 py-4">
            <Text className="text-gray-500  font-bold">Balance</Text>
            <View className="flex-row justify-center items-center mt-1">
              {/* <Text className="text-gray-800 font-semibold mr-2">XAF</Text> */}
              {balanceLoading ? (
                <ActivityIndicator size="small" color="#8f08fdde" />
              ) : balance.length > 0 ? (
                <View className="flex-row justify-center items-center">
                  <Text className="text-xl font-bold tracking-widest">
                    {view ? formatCurrency(balance[0]) : "******"}
                  </Text>
                  <Pressable className="ml-2" onPress={() => setView(!view)}>
                    {view ? (
                      <Eye size={18} color="gray" />
                    ) : (
                      <EyeOffIcon size={18} color="gray" />
                    )}
                  </Pressable>
                </View>
              ) : (
                <Text>Failed</Text>
              )}
            </View>
            <TouchableOpacity
              className="bg-primary/10 p-3 rounded-3xl flex flex-row justify-center items-center"
              onPress={depositModal.showModal}
            >
              <PlusIcon color={"#8f08fdde"} size={16} />
              <Text className="text-primary font-medium">Deposit</Text>
            </TouchableOpacity>
          </View>

          {/* tryers */}
          <View className="mt-3 flex flex-row justify-between items-center gap-1">
            {/* personal savings */}
            <TouchableOpacity
              className="flex flex-col w-1/2 px-8 py-4 justify-center items-center border rounded-lg border-gray-300"
              onPress={() => router.push("/PersonalSavings")}
            >
              <PiggyBank className="text-primary" color="#8f08fdde" />
              <View className="mt-3 flex justify-center items-center">
                <Text className="items-center font-light">
                  Personal Savings
                </Text>
              </View>
            </TouchableOpacity>
            {/* Expense tracking */}
            <TouchableOpacity
              className="flex flex-col px-8 py-4 w-1/2 justify-center items-center border rounded-lg border-gray-300"
              onPress={() => router.push("/ExpenseTracking")}
            >
              <Receipt className="text-primary" color="#8f08fdde" />
              <View className="mt-3 flex justify-center items-center">
                <Text className="items-center font-light">
                  Expense Tracking
                </Text>
              </View>
            </TouchableOpacity>
          </View>
          {/* transactions */}
          <View className="mt-4">
            <TouchableOpacity
              className="flex flex-col px-4 py-6 w-full justify-center items-center border rounded-lg border-gray-300"
              onPress={refresh}
            >
              <ArrowLeftRight className="text-primary" color="#8f08fdde" />
              <View className="mt-3 flex justify-center items-center">
                <Text className="items-center font-light">Transactions</Text>
              </View>
            </TouchableOpacity>
          </View>

          {/* Transaction history */}
          <View className="mt-10">
            <Text className="font-extrabold text-gray-600 text-xl">
              Transaction History
            </Text>
            {notificationsLoading ? (
              <ActivityIndicator size="small" color="#8f08fdde" />
            ) : notifications.length > 0 ? (
              <ScrollView className="mt-4">
                {notifications.slice(0, 10).map((notif) => (
                  <View
                    key={notif.id}
                    className="bg-gray-50 p-3 rounded-lg mb-2"
                  >
                    <Text className="text-gray-800">
                      {formatNotification(notif)}
                    </Text>
                  </View>
                ))}
              </ScrollView>
            ) : (
              <View className="flex justify-center items-center pt-20">
                <ArrowLeftRight className="text-primary" color="#d1d5db" />
                <Text className="text-xl text-gray-300">
                  No-Transactions-Yet..
                </Text>
              </View>
            )}
          </View>

          {/* notification Modal */}
          <ModalBrand
            title="All Transactions"
            visible={showNotification.isVissible}
            onrequestclose={showNotification.hideModal}
            content={
              <View className="flex-1 mt-4 px-4">
                {notificationsLoading ? (
                  <ActivityIndicator size="small" color="#8f08fdde" />
                ) : notifications.length > 0 ? (
                  <ScrollView className="flex-1">
                    {notifications.map((notif) => (
                      <View
                        key={notif.id}
                        className="bg-gray-50 p-3 rounded-lg mb-2 w-full"
                      >
                        <Text className="text-gray-800">
                          {formatNotification(notif)}
                        </Text>
                      </View>
                    ))}
                  </ScrollView>
                ) : (
                  <Text>No transactions yet.</Text>
                )}
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
                  <ButtonBrand
                    text={"Deposit"}
                    fxn={deposit}
                    disabled={isValid()}
                  />
                </View>
              </View>
            }
          />
        </ScrollView>
      </SafeAreaView>
    )
  );
}
