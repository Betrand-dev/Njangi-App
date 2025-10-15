import { AppTheme } from "@/app/config/theme";
import { StyleSheet } from "react-native";
import { Button, Text } from "react-native-paper";

const ButtonBrand = ({ text, fxn }) => {
  return (
    <Button mode="contained" onPress={fxn} style={styles.button}>
      <Text style={{ color: "white", fontSize: 18, fontWeight: "bold" }}>
        {text}
      </Text>
    </Button>
  );
};

const styles = StyleSheet.create({
  button: {
    paddingVertical: 10,
    borderRadius: 25,
    textAlign: "center",
    fontWeight: "heavy",
    fontSize: 20,
    // width: "90%",
    backgroundColor: AppTheme.colors.primary,
  },
});

export default ButtonBrand;
