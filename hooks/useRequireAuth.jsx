import { AuthContext } from "../app/contexts/AuthContext";
import { router } from "expo-router";
import { useContext, useEffect } from "react";

// Hook to require auth for a screen. If not logged in, redirect to /login.
export default function useRequireAuth() {
  const { user, loading } = useContext(AuthContext);

  useEffect(() => {
    if (!loading && !user) {
      router.replace("/login");
    }
  }, [loading, user]);

  return { user, loading };
}
