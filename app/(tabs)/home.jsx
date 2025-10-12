import { StyleSheet, Text, View } from "react-native";

const HomeTab = () => {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Welcome to ncap you njangi box</Text>
      <Text style={styles.subtitle}>This is your Home dashboard.</Text>
    </View>
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
