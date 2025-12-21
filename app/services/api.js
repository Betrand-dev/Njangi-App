import AsyncStorage from "@react-native-async-storage/async-storage";
import axios from "axios";

// CHANGE THIS to the address your app/device can reach (emulator vs real device)
// Options:
// - Expo web on same machine: http://127.0.0.1:5000
// - Android emulator: http://10.0.2.2:5000  
// - iOS simulator: http://127.0.0.1:5000
// - Physical device: your machine's IP (run `ipconfig` on Windows to find it)
export const BASE_URL = "http://192.168.110.203:5000"; // <-- Try this if running on same machine
//export const BASE_URL = "http://127.0.0.1:5000"; // <-- update to your backend

const api = axios.create({
    baseURL: BASE_URL,
    headers: { "Content-Type": "application/json" },
});

// helper keys
const ACCESS_KEY = "access_token";
const REFRESH_KEY = "refresh_token";

export const saveTokens = async ({ access, refresh }) => {
    try {
        if (access) await AsyncStorage.setItem(ACCESS_KEY, access);
        if (refresh) await AsyncStorage.setItem(REFRESH_KEY, refresh);
    } catch (e) {
        console.warn("Failed to save tokens", e);
    }
};

export const clearTokens = async () => {
    try {
        await AsyncStorage.removeItem(ACCESS_KEY);
        await AsyncStorage.removeItem(REFRESH_KEY);
    } catch (e) {
        console.warn("Failed to clear tokens", e);
    }
};

// Attach access token from AsyncStorage to every request if present
api.interceptors.request.use(
    async (config) => {
        try {
            const token = await AsyncStorage.getItem(ACCESS_KEY);
            if (token) {
                config.headers.Authorization = `Bearer ${token}`;
                console.log("Sending request with token:", config.url);
            } else {
                console.log("No token found for request:", config.url);
            }
        } catch (e) {
            console.warn("Failed to get token", e);
        }
        return config;
    },
    (error) => Promise.reject(error)
);

// Response interceptor: try refresh flow on 401
api.interceptors.response.use(
    (res) => res,
    async (error) => {
        const originalRequest = error.config;

        console.log("Response error:", error.response?.status, error.response?.data, "for", originalRequest?.url);

        // if no response or not 401, reject
        if (!error.response || error.response.status !== 401) {
            return Promise.reject(error);
        }

        // avoid infinite loop
        if (originalRequest._retry) {
            console.log("Already retried, rejecting");
            return Promise.reject(error);
        }
        originalRequest._retry = true;

        try {
            const refresh = await AsyncStorage.getItem(REFRESH_KEY);
            if (!refresh) {
                console.log("No refresh token");
                throw new Error("No refresh token");
            }

            console.log("Attempting refresh");
            // use a bare axios instance to call refresh endpoint (no interceptors)
            const plain = axios.create({ baseURL: BASE_URL });
            const response = await plain.post(
                "/auth/refresh",
                {},
                { headers: { Authorization: `Bearer ${refresh}` } }
            );

            const newAccess = response.data?.access_token;
            if (!newAccess) throw new Error("No access token returned");

            console.log("Refresh successful, saving new access token");
            // save new access token and retry original request
            await AsyncStorage.setItem(ACCESS_KEY, newAccess);
            originalRequest.headers.Authorization = `Bearer ${newAccess}`;
            return api(originalRequest);
        } catch (e) {
            console.log("Refresh failed:", e.message);
            // refresh failed: clear tokens and reject so app can handle re-login
            try {
                await clearTokens();
            } catch (ee) { }
            return Promise.reject(error);
        }
    }
);

// fetch current user using access token
export const getCurrentUser = async () => {
    const res = await api.get("/auth/me");
    return res.data;
};

export default api;
