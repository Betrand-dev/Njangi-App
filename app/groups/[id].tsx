// app/groups/[id].tsx
import { router, useLocalSearchParams } from 'expo-router';
import { ArrowLeftIcon, CheckCircleIcon, CopyIcon, DollarSignIcon, InboxIcon, TrashIcon, UserMinusIcon } from 'lucide-react-native';
import { useEffect, useState } from 'react';
import {
  ActivityIndicator,
  Alert,
  Clipboard,
  Pressable,
  ScrollView,
  Text,
  TouchableOpacity,
  View
} from 'react-native';
import { SafeAreaView } from "react-native-safe-area-context";
import ModalBrand from "../../components/ModalBrand";
import useModal from "../../hooks/useModal";
import useRequireAuth from '../hooks/useRequireAuth';
import api from '../services/api';


interface GroupData {
  id: number;
  name: string;
  code: string;
  description: string;
  admin_id: number;
  balance: number;
  frequency: string;
  start_date: string;
  end_date: string;
  contribution_amount: number;
  group_type: string;
  penalty: number;
  contribution_time: string;
  max_members: number;
  created_at: string;
}

interface Member {
  id: number;
  email: string;
  firstName: string;
  lastName: string;
  role: string;
}

interface Contribution {
  id: number;
  user_id: number;
  amount: number;
  status: string;
  created_at: string;
  user_name?: string;
}

export default function GroupDetailsPage() {
  const modal = useModal();
  const { id } = useLocalSearchParams();
  const { user } = useRequireAuth();
  const [group, setGroup] = useState<GroupData | null>(null);
  const [members, setMembers] = useState<Member[]>([]);
  const [contributions, setContributions] = useState<Contribution[]>([]);
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [actionLoading, setActionLoading] = useState(false);

  useEffect(() => {
    fetchGroupDetails();
  }, [id]);

  const fetchGroupDetails = async () => {
    if (!id) {
      console.log('No ID provided');
      return;
    }

    console.log('Fetching group details for ID:', id, typeof id);
    setLoading(true);
    try {
      // Fetch group details
      console.log('Making API call to:', `/groups/${id}`);
      const groupResponse = await api.get(`/groups/${id}`);
      console.log('API Response:', groupResponse.data);

      const groupData = groupResponse.data.group;
      const membersData = groupResponse.data.members;

      console.log('Group data:', groupData);
      console.log('Members data:', membersData);

      setGroup(groupData);
      setMembers(membersData);

      // Check if current user is admin
      const currentUserMember = membersData.find((member: Member) => member.id === user?.profile?.id);
      setIsAdmin(currentUserMember?.role === 'admin');

      // Fetch recent contributions
      try {
        const contributionsResponse = await api.get(`/groups/${id}/contributions`);
        setContributions(contributionsResponse.data.contributions || []);
      } catch (error) {
        console.error('Failed to fetch contributions:', error);
        setContributions([]);
      }

    } catch (error: any) {
      console.error('Failed to fetch group details:', error);
      console.error('Error response:', error.response?.data);
      console.error('Error status:', error.response?.status);
      console.error('Error config:', error.config);

      const errorMessage = error.response?.data?.message || 'Failed to load group details';
      Alert.alert('Error', errorMessage);
      router.back();
    } finally {
      setLoading(false);
    }
  };

  const copyGroupCode = async () => {
    if (group?.code) {
      await Clipboard.setString(group.code);
      Alert.alert('Success', 'Group code copied to clipboard!');
    }
  };

  const removeMember = async (memberId: number, memberName: string) => {
    Alert.alert(
      'Remove Member',
      `Are you sure you want to remove ${memberName} from this group?`,
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Remove',
          style: 'destructive',
          onPress: async () => {
            setActionLoading(true);
            try {
              await api.delete(`/groups/${id}/members/${memberId}`);
              Alert.alert('Success', 'Member removed successfully');
              fetchGroupDetails(); // Refresh the data
            } catch (error: any) {
              console.error('Failed to remove member:', error);
              Alert.alert('Error', 'Failed to remove member');
            } finally {
              setActionLoading(false);
            }
          }
        }
      ]
    );
  };

  const deleteGroup = async () => {
    Alert.alert(
      'Delete Group',
      'Are you sure you want to delete this group? This action cannot be undone and all data will be lost.',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Delete',
          style: 'destructive',
          onPress: async () => {
            setActionLoading(true);
            try {
              await api.delete(`/groups/${id}`);
              Alert.alert('Success', 'Group deleted successfully');
              router.replace('/(tabs)/groups'); // Go back to groups list
            } catch (error: any) {
              console.error('Failed to delete group:', error);
              Alert.alert('Error', 'Failed to delete group');
            } finally {
              setActionLoading(false);
            }
          }
        }
      ]
    );
  };

  const confirmContribution = async (contributionId: number) => {
    setActionLoading(true);
    try {
      await api.post(`/groups/${id}/contributions/${contributionId}/confirm`);
      Alert.alert('Success', 'Contribution confirmed successfully');
      fetchGroupDetails(); // Refresh the data
    } catch (error: any) {
      console.error('Failed to confirm contribution:', error);
      Alert.alert('Error', 'Failed to confirm contribution');
    } finally {
      setActionLoading(false);
    }
  };

  const makeContribution = async () => {
    if (!group) return;

    Alert.alert(
      'Make Contribution',
      `Contribute ${formatCurrency(group.contribution_amount)} to this group?`,
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Contribute',
          onPress: async () => {
            setActionLoading(true);
            try {
              await api.post(`/groups/${id}/contributions`, {
                amount: group.contribution_amount
              });
              Alert.alert('Success', 'Contribution submitted successfully');
              fetchGroupDetails(); // Refresh the data
            } catch (error: any) {
              console.error('Failed to make contribution:', error);
              Alert.alert('Error', 'Failed to make contribution');
            } finally {
              setActionLoading(false);
            }
          }
        }
      ]
    );
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  };

  const formatTime = (time: string) => {
    return new Date(time).toLocaleTimeString();
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'XAF',
    }).format(amount);
  };

  if (loading) {
    return (
      <SafeAreaView className="flex-1 bg-background justify-center items-center">
        <ActivityIndicator size="large" color="#8f08fdde" />
        <Text className="mt-4 text-gray-600">Loading...</Text>
      </SafeAreaView>
    );
  }

  if (!group) {
    return (
      <SafeAreaView className="flex-1 bg-background justify-center items-center">
        <Text className="text-gray-600">Group not found</Text>
        <TouchableOpacity
          onPress={() => router.back()}
          className="mt-4 px-6 py-2 bg-primary rounded-lg"
        >
          <Text className="text-white font-semibold">Go Back</Text>
        </TouchableOpacity>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView className="flex-1 bg-background">
      {/* Header */}
      <View className="flex flex-row justify-between items-center px-4 py-6 bg-white border-b border-gray-200">
        <View className="flex flex-row">
          <TouchableOpacity onPress={() => router.back()} className="mr-3">
          <ArrowLeftIcon size={24} color="#374151" />
        </TouchableOpacity>
        <View className="">
          <Text className="text-xl font-bold text-gray-900">{group.name}</Text>
        </View>
        </View>
        <View>
          <Pressable onPress={modal.showModal}>
            <InboxIcon className="text-primary" color="#8f08fdde" />
          </Pressable>
        </View>
      </View>

      <ScrollView className="flex-1" showsVerticalScrollIndicator={false}>

        {/* Pending Contributions Section (Admin Only) */}
        {isAdmin && contributions.length > 0 && (
          <View className="mx-4 mt-6">
            <Text className="text-lg font-semibold text-gray-900 mb-4">Pending Contributions</Text>
            <View className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
              {contributions.filter(c => c.status === 'pending').map((contribution, index) => (
                <View
                  key={contribution.id}
                  className={`flex-row items-center justify-between p-4 ${
                    index !== contributions.filter(c => c.status === 'pending').length - 1 ? 'border-b border-gray-100' : ''
                  }`}
                >
                  <View className="flex-row items-center">
                    <View className="w-10 h-10 bg-yellow-100 rounded-full items-center justify-center mr-3">
                      <DollarSignIcon size={20} color="#f59e0b" />
                    </View>
                    <View>
                      <Text className="font-medium text-gray-900">
                        {contribution.user_name || `User ${contribution.user_id}`}
                      </Text>
                      <Text className="text-sm text-gray-500">
                        {formatCurrency(contribution.amount)} • {formatDate(contribution.created_at)}
                      </Text>
                    </View>
                  </View>
                  <TouchableOpacity
                    onPress={() => confirmContribution(contribution.id)}
                    disabled={actionLoading}
                    className="bg-green-500 px-4 py-2 rounded-lg"
                  >
                    <Text className="text-white font-semibold text-sm">Confirm</Text>
                  </TouchableOpacity>
                </View>
              ))}
            </View>
          </View>
        )}

        {/* Recent Contributions Section */}
        <View className="mx-4 mt-6 mb-6">
          <Text className="text-lg font-semibold text-gray-900 mb-4">Recent Contributions</Text>
          {contributions.filter(c => c.status === 'confirmed').length > 0 ? (
            <View className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
              {contributions.filter(c => c.status === 'confirmed').slice(0, 5).map((contribution, index) => (
                <View
                  key={contribution.id}
                  className={`flex-row items-center justify-between p-4 ${
                    index !== Math.min(contributions.filter(c => c.status === 'confirmed').length, 5) - 1 ? 'border-b border-gray-100' : ''
                  }`}
                >
                  <View className="flex-row items-center">
                    <View className="w-10 h-10 bg-green-100 rounded-full items-center justify-center mr-3">
                      <CheckCircleIcon size={20} color="#10b981" />
                    </View>
                    <View>
                      <Text className="font-medium text-gray-900">
                        {contribution.user_name || `User ${contribution.user_id}`}
                      </Text>
                      <Text className="text-sm text-gray-500">
                        {formatCurrency(contribution.amount)} • {formatDate(contribution.created_at)}
                      </Text>
                    </View>
                  </View>
                  <View className="bg-green-100 px-2 py-1 rounded-full">
                    <Text className="text-xs font-medium text-green-600">Confirmed</Text>
                  </View>
                </View>
              ))}
            </View>
          ) : (
            <View className="bg-white rounded-xl shadow-sm border border-gray-100 p-6 items-center justify-center">
              <Text className="text-gray-500 text-center">No contributions yet</Text>
              <Text className="text-sm text-gray-400 text-center mt-1">
                Contributions will appear here once members start contributing
              </Text>
            </View>
          )}
        </View>

        <ModalBrand 
        visible={modal.isVissible}
        onrequestclose={modal.hideModal}
          title="Group details"
          content={
          <View>
            <View className="mx-1 mt-6">
              <Text className="text-lg font-semibold text-gray-900 mb-4">Group Overview</Text>
              <View className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
                  <View className="flex-row justify-between items-center border-b border-gray-100">
                    <View>
                      <Text className='p-3 font-bold text-xl'>{group.name}</Text>
                    </View>
                    <View>
                      <Text className='p-3 text-primary'>{group.group_type}.</Text>
                    </View>
                  </View>

                  <View className="flex-row justify-between items-center border-b border-gray-100">
                    <View>
                      <Text className='p-3 font-bold text-md'>Frequency</Text>
                    </View>
                    <View>
                      <Text className='p-3 font-semibold text-gray-600'>{group.frequency}</Text>
                    </View>
                  </View>

                  <View className="flex-row justify-between items-center border-b border-gray-100">
                    <View>
                      <Text className='p-3 font-bold text-md'>Contribution Amount</Text>
                    </View>
                    <View>
                      <Text className='p-3 font-semibold text-gray-600'>{formatCurrency(group.contribution_amount)}</Text>
                    </View>
                  </View>

                  <View className="flex-row justify-between items-center border-b border-gray-100">
                    <View>
                      <Text className='p-3 font-bold text-md'>Penalty Amount</Text>
                    </View>
                    <View>
                      <Text className='p-3 font-semibold text-gray-600'>{formatCurrency(group.penalty)}</Text>
                    </View>
                  </View>

                  <View className="flex-row justify-between items-center border-b border-gray-100">
                    <View>
                      <Text className='p-3 font-bold text-md'>Created At</Text>
                    </View>
                    <View>
                      <Text className='p-3 font-semibold text-gray-600'>{formatDate(group.created_at)}</Text>
                    </View>
                  </View>

                  {isAdmin && (
                    <View className="border-b border-gray-100">
                      <View className="flex-row justify-between items-center p-3">
                        <View>
                          <Text className='font-bold text-md'>Group Code</Text>
                          <Text className='text-sm text-gray-500'>Share this code to invite members</Text>
                        </View>
                        <TouchableOpacity
                          onPress={copyGroupCode}
                          className="flex-row items-center bg-primary/10 px-3 py-2 rounded-lg"
                        >
                          <Text className='font-semibold text-primary mr-2'>{group.code}</Text>
                          <CopyIcon size={16} color="#8f08fdde" />
                        </TouchableOpacity>
                      </View>
                    </View>
                  )}

                  {isAdmin && (
                    <View className="p-3">
                      <TouchableOpacity
                        onPress={deleteGroup}
                        disabled={actionLoading}
                        className="flex-row items-center justify-center bg-red-500 py-3 rounded-lg"
                      >
                        <TrashIcon size={18} color="white" className="mr-2" />
                        <Text className="text-white font-semibold ml-2">Delete Group</Text>
                      </TouchableOpacity>
                    </View>
                  )}
              </View>
              
            </View>
        {/* Members Section */}
        <View className="mx-1 mt-6">
          <Text className="text-lg font-semibold text-gray-900 mb-4">Members ({members.length})</Text>
          <View className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
            {members.map((member, index) => (
              <View
                key={member.id}
                className={`flex-row items-center justify-between p-4 ${
                  index !== members.length - 1 ? 'border-b border-gray-100' : ''
                }`}
              >
                <View className="flex-row items-center">
                  <View className="w-10 h-10 bg-primary/10 rounded-full items-center justify-center mr-3">
                    <Text className="font-semibold text-primary">
                      {(member.firstName?.[0] || '') + (member.lastName?.[0] || '')}
                    </Text>
                  </View>
                  <View>
                    <Text className="font-medium text-gray-900">
                      {member.firstName} {member.lastName}
                    </Text>
                    <Text className="text-sm text-gray-500">{member.email}</Text>
                  </View>
                </View>
                <View className="flex-row items-center">
                  <View className={`px-2 py-1 rounded-full mr-2 ${
                    member.role === 'admin' ? 'bg-primary/10' : 'bg-gray-100'
                  }`}>
                    <Text className={`text-xs font-medium capitalize ${
                      member.role === 'admin' ? 'text-primary' : 'text-gray-600'
                    }`}>
                      {member.role}
                    </Text>
                  </View>
                  {isAdmin && member.id !== user?.profile?.id && (
                    <TouchableOpacity
                      onPress={() => removeMember(member.id, `${member.firstName} ${member.lastName}`)}
                      disabled={actionLoading}
                      className="p-1"
                    >
                      <UserMinusIcon size={16} color="#ef4444" />
                    </TouchableOpacity>
                  )}
                </View>
              </View>
            ))}
          </View>
        </View>

        {/* Pending Contributions Section (Admin Only) */}
        {isAdmin && contributions.filter(c => c.status === 'pending').length > 0 && (
          <View className="mx-1 mt-6">
            <Text className="text-lg font-semibold text-gray-900 mb-4">Pending Contributions</Text>
            <View className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
              {contributions.filter(c => c.status === 'pending').map((contribution, index) => (
                <View
                  key={contribution.id}
                  className={`flex-row items-center justify-between p-4 ${
                    index !== contributions.filter(c => c.status === 'pending').length - 1 ? 'border-b border-gray-100' : ''
                  }`}
                >
                  <View className="flex-row items-center">
                    <View className="w-10 h-10 bg-yellow-100 rounded-full items-center justify-center mr-3">
                      <DollarSignIcon size={20} color="#f59e0b" />
                    </View>
                    <View>
                      <Text className="font-medium text-gray-900">
                        {contribution.user_name || `User ${contribution.user_id}`}
                      </Text>
                      <Text className="text-sm text-gray-500">
                        {formatCurrency(contribution.amount)} • {formatDate(contribution.created_at)}
                      </Text>
                    </View>
                  </View>
                  <TouchableOpacity
                    onPress={() => confirmContribution(contribution.id)}
                    disabled={actionLoading}
                    className="bg-green-500 px-4 py-2 rounded-lg"
                  >
                    <Text className="text-white font-semibold text-sm">Confirm</Text>
                  </TouchableOpacity>
                </View>
              ))}
            </View>
          </View>
        )}

        {/* Recent Contributions Section */}
        {isAdmin && (
          <View className="mx-1 mt-6">
            <Text className="text-lg font-semibold text-gray-900 mb-4">Recent Contributions</Text>
            {contributions.filter(c => c.status === 'confirmed').length > 0 ? (
              <View className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
                {contributions.filter(c => c.status === 'confirmed').slice(0, 5).map((contribution, index) => (
                  <View
                    key={contribution.id}
                    className={`flex-row items-center justify-between p-4 ${
                      index !== Math.min(contributions.filter(c => c.status === 'confirmed').length, 5) - 1 ? 'border-b border-gray-100' : ''
                    }`}
                  >
                    <View className="flex-row items-center mb-4">
                      <View className="w-10 h-10 bg-green-100 rounded-full items-center justify-center mr-3">
                        <CheckCircleIcon size={20} color="#10b981" />
                      </View>
                      <View>
                        <Text className="font-medium text-gray-900">
                          {contribution.user_name || `User ${contribution.user_id}`}
                        </Text>
                        <Text className="text-sm text-gray-500">
                          {formatCurrency(contribution.amount)} • {formatDate(contribution.created_at)}
                        </Text>
                      </View>
                    </View>
                    <View className="bg-green-100 px-2 py-1 rounded-full">
                      <Text className="text-xs font-medium text-green-600">Confirmed</Text>
                    </View>
                  </View>
                ))}
              </View>
            ) : (
              <View className="bg-white rounded-xl shadow-sm border border-gray-100 p-6 items-center justify-center mb-4">
                <Text className="text-gray-500 text-center">No contributions yet</Text>
                <Text className="text-sm text-gray-400 text-center mt-1">
                  Contributions will appear here once members start contributing
                </Text>
              </View>
            )}
          </View>
        )}

            </View>
          }
        />

        {/* Action Buttons */}
        <View className="mx-4 mb-6 space-y-3">
          {/* Make Contribution button for everyone */}
          <TouchableOpacity
            onPress={makeContribution}
            disabled={actionLoading}
            className="bg-primary py-4 rounded-xl items-center"
          >
            <Text className="text-white font-semibold text-lg">Make Contribution</Text>
          </TouchableOpacity>

          
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}