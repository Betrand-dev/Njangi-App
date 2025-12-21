import { router } from "expo-router";
import { useContext, useEffect, useState } from "react";
import { AuthContext } from "../contexts/AuthContext";
import { getCurrentUser } from "../services/api";

const useRequireAuth = () => {
  const { user, setUser, logout } = useContext(AuthContext);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchUser = async () => {
      if (!user) {
        try {
          const userData = await getCurrentUser();
          setUser(userData);
        } catch (error) {
          console.error("Failed to fetch user:", error);
          // If fetching fails, logout and redirect to login
          await logout();
          router.replace("/login");
          return;
        }
      }
      setLoading(false);
    };

    fetchUser();
  }, [user, setUser, logout]);

  return { user, loading };
};

export default useRequireAuth;
