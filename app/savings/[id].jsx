import { router, useLocalSearchParams } from 'expo-router';
import { ArrowLeftIcon, InfoIcon, RefreshCwIcon } from "lucide-react-native";
import { useEffect, useState } from 'react';
import { Alert, Pressable, ScrollView, Text, TouchableOpacity, View, ActivityIndicator } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import ButtonBrand from '../../components/ButtonBrand';
import InputBrand from '../../components/InputBrand';
import ModalBrand from '../../components/ModalBrand';
import useModal from '../../hooks/useModal';
import useRequireAuth from "../hooks/useRequireAuth";
import api from "../services/api";

const SavingDetail = () => {
    const { id, name, goal, frequency, date } = useLocalSearchParams();
    const { user, loading: authLoading } = useRequireAuth();
    const [savingLoading, setSavingLoading] = useState(false);
    const [saves, setSaves] = useState([]);
    const [sendLoading, setSendLoading] = useState(false);
    const modal = useModal();
    const infoModal = useModal();
    const [amount, setAmount] = useState({
        value: ""
    });
    const formatCurrency = (amount) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'XAF',
    }).format(amount);
  };

  const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  };

    useEffect(() => {
    const fetchSaving = async () => {
      
      setSavingLoading(true);
      try {
        const response = await api.get(`/savings/${id}`);
        console.log(response.data.saves);
        setSaves(response.data.saves || []);
      }
      catch (error) {
        console.error("Failed to fetch saves:", error);
      } finally {
        setSavingLoading(false);
      }
    };

    fetchSaving()
  }, [user]);

   // refresh expenses
    const refreshSaves = async () => {
      if (!user) return;
      setSavingLoading(true);
      try {
        const response = await api.get(`/savings/${id}`);
        setExpenses(response.data.saves || []);
      } catch (error) {
        console.error("Failed to refresh saves:", error);
        Alert.alert("Error", "Failed to refresh saves");
      } finally {
        setSavingLoading(false);
      }
    };


  const amountUpdate = (field, value) => {
    setAmount((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

//   destructuring object
const {value} = amount;
 
    const createSaving = async () => {
        const data = {
            value,
        }
    setSendLoading(true);
    try{
        const response = await api.post(`/savings/${id}`, data);
        Alert.alert("success", "saving created");
    } catch (error){
        console.log(error);
        Alert.alert("error", "failed to create saving");
    } finally{
        setSendLoading(false);
    }
    }

  const isValid = () => {
    return value.trim() == ""
  }


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
            onPress={refreshSaves}
            disabled={savingLoading}
            className="mr-3"
            >
            <RefreshCwIcon
            className={`text-primary ${savingLoading ? "opacity-50" : ""}`}
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
                    Target-Amount: 
                </Text>
                <Text>
                    {formatCurrency(goal)}
                </Text>
            </View>
            <View className="flex flex-row justify-between items-center border-b border-gray-200 p-2">
                <Text>
                    Amount-Saved: 
                </Text>
                <Text>
                    0
                </Text>
            </View>
            <View className="flex flex-row justify-between items-center border-b border-gray-200 p-2">
                <Text>Target Date: </Text>
                <Text>
                    {formatDate(date)}
                </Text>
            </View>
            <View className="mt-2">
                <ButtonBrand text={"deposit"} fxn={() => {modal.showModal()}}/>
            </View>
        </View>

        <View className="mx-4 mt-4 border border-gray-200 bg-white rounded-lg px-4 py-4">
            <View className="flex flex-row justify-between items-center border-b border-gray-200 p-2">
                <Text className="text-gray-800 text-xl">
                    Date.
                </Text>
                <Text className="text-gray-800 text-xl">
                    Amount.
                </Text>
            </View>
            {savingLoading ? (
                <View className="flex-1 justify-center items-center mt-40">
                    <ActivityIndicator size="large" color="#8f08fdde" />
                    <Text>Loading..</Text>
                </View>
            ) : saves.length < 0 ? (
                <View className="self-center mt-3">
                    <Text className="text-gray-800 font-semibold">No deposit</Text>
                </View>
            ) : (
                saves.map((save) => (
                <View className="flex flex-row justify-between items-center border-b border-gray-200 p-2" key={save.id}>
                    <Text className="text-gray-800 font-light text-lg">
                        {formatDate(save.created_at)}
                    </Text>
                    <Text className="text-gray-800 font-light text-lg">
                        {formatCurrency(save.amount)}
                    </Text>
                </View>
                ))
            )}
        </View>
        

        <ModalBrand 
        visible={modal.isVissible}
        title={"deposit"}
        onrequestclose={modal.hideModal}
        content={
            <View>
                <View>
                <InputBrand
                value={amount.value}
                onchange={(text) => (amountUpdate("value",text))}
                placeholder={"Enter amount"}
                type={"number"}
                />
                </View>
                <View>
                    <ButtonBrand text={"submit"} fxn={createSaving} disabled={isValid()}/>
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
                Frequency: {frequency}
              </Text>
            </View>
            <View className="border-b border-gray-200">
              <Text className="text-gray-800 font-bold text-lg p-3">
                Goal: {goal}
              </Text>
            </View>
            <View className="border-b border-gray-200">
              <Text className="text-gray-800 font-bold text-lg p-3">
                Targert-date: {formatDate(date)}
              </Text>
            </View>
            <View>
              <Pressable className="rounded-lg bg-red-600 p-2">
                <Text className="text-white text-center text-lg font-bold">Delete Profile</Text>
              </Pressable>
            </View>
          </View>
        } 
        />

    </ScrollView>
    </SafeAreaView>
  )
}

export default SavingDetail