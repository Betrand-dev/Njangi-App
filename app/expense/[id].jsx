import { View, Text, TouchableOpacity, Pressable, ScrollView, Alert, ActivityIndicator } from 'react-native'
import React, { useState, useEffect } from 'react'
import { router, useLocalSearchParams } from 'expo-router';
import { SafeAreaView } from 'react-native-safe-area-context';
import { ArrowLeftIcon, RefreshCwIcon, InfoIcon } from "lucide-react-native";
import ButtonBrand from '../../components/ButtonBrand';
import { AuthContext } from "../contexts/AuthContext";
import api from "../services/api";
import useRequireAuth from "../hooks/useRequireAuth";
import useModal from '../../hooks/useModal';
import ModalBrand from '../../components/ModalBrand';
import InputBrand from '../../components/InputBrand';

const ExpenceDetail = () => {
    const { id, name, description } = useLocalSearchParams();
    const { user, loading: authLoading } = useRequireAuth();
    const [expenseLoading, setExpenseLoading] = useState(false);
    const [expenses, setExpenses] = useState([]);
    const [totalExpenses, setTotalExpenses] = useState([]);
    const modal = useModal();
    const infoModal = useModal();
    const [sendLoading, setSendLoading] = useState(false);
        const [actionLoading, setActionLoading] = useState(false);
    const [expenseData, setExpenseData] = useState({
        item: "",
        describe: "",
        amount: ""
    });
    const {item, describe, amount} = expenseData;


    useEffect(() => {
    const fetchExpense = async () => {
      
      setExpenseLoading(true);
      try {
        const response = await api.get(`/expend/${id}`);
        setExpenses(response.data.expense || []);
        setTotalExpenses(response.data.total_expenses || [])
      }
      catch (error) {
        console.error("Failed to fetch expense:", error);
      } finally {
        setExpenseLoading(false);
      }
    };

    fetchExpense()
  }, [user]);

     // refresh expenses
    const refreshExpenses = async () => {
      if (!user) return;
      setExpenseLoading(true);
      try {
        const response = await api.get(`/expend/${id}`);
        setExpenses(response.data.expense || []);
      } catch (error) {
        console.error("Failed to refresh expense:", error);
        Alert.alert("Error", "Failed to refresh expense");
      } finally {
        setExpenseLoading(false);
      }
    };

    const createExpense = async () => {
        const data = {
            item,
            describe,
            amount,
        }
    setSendLoading(true);
    try{
        const response = await api.post(`/expend/${id}`, data);
        Alert.alert("success", "expense created");
    } catch (error){
        console.log(error);
        Alert.alert("error", "failed to create expense");
    } finally{
        setSendLoading(false);
    }
    }

    const expenseUpdate = (field, value) => {
    setExpenseData((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  const isValid = () => {
    return item.trim() == "" && describe.trim() == "" && amount.trim() == "";
  }

    const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  };

  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'XAF',
    }).format(amount);
  };

  const deleteProfile = async () => {
      Alert.alert(
        'Delete Profile',
        'Are you sure you want to delete this profile? This action cannot be undone and all data will be lost.',
        [
          { text: 'Cancel', style: 'cancel' },
          {
            text: 'Delete',
            style: 'destructive',
            onPress: async () => {
              setActionLoading(true);
              try {
                await api.delete(`/delete_expense_profile/${id}`);
                Alert.alert('Success', 'Profile deleted successfully');
                router.replace('/ExpenseTracking'); // Go back to profile list
              } catch (error) {
                console.error('Failed to delete Profile:', error);
                Alert.alert('Error', 'Failed to delete Profile');
              } finally {
                setActionLoading(false);
              }
            }
          }
        ]
      );
    };

  return (
    <SafeAreaView className="flex-1 bg-background">
        {/* Header */}
      <View className="flex flex-row justify-between items-center pt-8 pb-5 px-3 bg-white border-b border-gray-200">
        <View className="flex flex-row">
          <TouchableOpacity onPress={() => router.back()} className="mr-3">
            <ArrowLeftIcon size={24} color="#374151" />
          </TouchableOpacity>
          <View className="">
            <Text className="text-xl font-bold text-gray-900">
              {name}
            </Text>
          </View>
        </View>
        <View className="flex-row items-center gap-1 space-x-3">
        <Pressable
          onPress={refreshExpenses}
          disabled={expenseLoading}
            className="mr-3"
          >
            <RefreshCwIcon
            className={`text-primary ${expenseLoading ? "opacity-50" : ""}`}
            color="#8f08fdde"
            />
          </Pressable>
          <Pressable
          onPress={infoModal.showModal}
          >
            <InfoIcon className="text-primary" color="#8f08fdde" />
          </Pressable>
        </View>
      </View>
      <ScrollView>
        <View className="mx-4 mt-4 border border-gray-200 bg-white rounded-lg px-4 py-4">
            <View className="flex flex-row justify-between items-center border-b border-gray-200 p-2">
                <Text>
                    Total-Expenditures: 
                </Text>
                <Text>
                    {formatCurrency(totalExpenses?.total_expenses)}-
                </Text>
            </View>
            <View className="mt-2">
                <ButtonBrand text={"Add Expenditure"} fxn={modal.showModal}/>
            </View>
        </View>

        <View className="mx-4 mt-4 border border-gray-200 bg-white rounded-lg px-4 py-4">
            <View className="flex flex-row justify-between items-center border-b border-gray-200 p-2">
                <Text className="text-gray-800 text-xl">
                    Date.
                </Text>
                <Text className="text-gray-800 text-xl">
                    Item.
                </Text>
                <Text className="text-gray-800 text-xl">
                    Amount.
                </Text>
            </View>

            {expenseLoading ? (
                <View className="flex-1 justify-center items-center mt-40">
                    <ActivityIndicator size="large" color="#8f08fdde" />
                    <Text className="text-gray-800 font-semibold">Loading..</Text>
                </View>
            ) : expenses < 0 ? (
                <View className="self-center mt-3">
                    <Text className="text-gray-800 font-semibold">No Expenses</Text>
                </View>
            ) : (
                expenses.map((expense) => (
                <View className="flex flex-row justify-between items-center border-b border-gray-200 p-2" key={expense.id}>
                    <Text className="text-gray-800 font-light text-lg">
                        {formatDate(expense.created_at)}
                    </Text>
                    <Text className="text-gray-800 font-light text-lg">
                        {expense.merchant}
                    </Text>
                    <Text className="text-gray-800 font-light text-lg">
                        {formatCurrency(expense.amount)}
                    </Text>
                </View>
                ))
            )}
        </View>

        <ModalBrand 
        visible={modal.isVissible}
        onrequestclose={modal.hideModal}
        title={"Create Expense"}
        content={
            <View>
                <Text className="ml-2 font-bold text-gray-600 text-lg">Item</Text>
                <View className="mt-3">
                <InputBrand 
                value={item}
                onchange={(text) => expenseUpdate("item",text)}
                placeholder={"item"}
                type={"text"}
                />
                </View>


                <Text className="ml-2 font-bold text-gray-600 text-lg">Amount</Text>
                <View className="mt-3">
                <InputBrand 
                value={amount}
                onchange={(text) => expenseUpdate("amount",text)}
                placeholder={"Amount(price)"}
                type={"number"}
                />
                </View>


                <Text className="ml-2 font-bold text-gray-600 text-lg">Describe</Text>
                <View className="mt-3">
                <InputBrand 
                value={describe}
                onchange={(text) => expenseUpdate("describe",text)}
                placeholder={"describe"}
                type={"textarea"}
                />
                </View>

                <View className="mt-3">
                    <ButtonBrand text={"ADD"} disabled={isValid()} fxn={createExpense}/>
                </View>
            </View>
        }
        />

        <ModalBrand
        visible={infoModal.isVissible}
        onrequestclose={infoModal.hideModal}
        title={"Info"}
        content={
          <View className="bg-white mx-4 px-4 py-3 border border-gray-200 rounded-lg">
            <View className="border-b border-gray-200">
              <Text className="text-gray-800 font-bold text-lg p-3">
                {name}
              </Text>
            </View>
            <View className="border-b border-gray-200">
              <Text className="text-gray-800 font-bold text-lg p-3">
                Description
              </Text>
              <View>
                <Text className="font-light text-lg p-3">
                  {description}
                </Text>
              </View>
            </View>
            <View>
              <Pressable className="rounded-lg bg-red-600 p-2" onPress={deleteProfile} disabled={actionLoading}>
                <Text className="text-white font-bold text-xl text-center">Delete Profile</Text>
              </Pressable>
            </View>
          </View>
        }
        />

      </ScrollView>
    </SafeAreaView>
  )
}

export default ExpenceDetail