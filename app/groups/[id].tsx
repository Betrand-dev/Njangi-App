    // app/groups/[id].tsx
    import { useLocalSearchParams } from 'expo-router';
    import { View, Text } from 'react-native';
    import { SafeAreaView } from "react-native-safe-area-context";

    export default function UserProfilePage() {
      const { id } = useLocalSearchParams(); // 'id' matches the file name '[id]'

      return (
        <SafeAreaView className="flex-1 bg-background">
          <Text className='ml-12 mt-10'>{id}</Text>
        </SafeAreaView>
      );
    }