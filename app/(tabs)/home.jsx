import { StyleSheet, Text, View , ScrollView } from "react-native";
import { SafeAreaView, SafeAreaProvider  } from "react-native-safe-area-context";

const HomeTab = () => {
  return (
    <SafeAreaProvider>
      <SafeAreaView style={styles.container}>
        
          <Text style={styles.title}>Home Screen</Text>
          <Text style={styles.subtitle}>Welcome to the Home Tab</Text>
      </SafeAreaView>
    </SafeAreaProvider>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
    backgroundColor: "#fff",
  },
  title: {
    fontSize: 24,
    fontWeight: "bold",
  },
  subtitle: {
    color: "#777",
    marginTop: 10,
  },
});

export default HomeTab;
