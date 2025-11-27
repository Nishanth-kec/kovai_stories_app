import axios from "axios";

export const sendAutomationEvent = async (event, data) => {
  if (!process.env.AUTOMATION_WEBHOOK_URL) return;

  try {
    await axios.post(process.env.AUTOMATION_WEBHOOK_URL, {
      event,
      timestamp: new Date(),
      data
    });
  } catch (err) {
    console.warn("⚠ Webhook failed:", err.message);
  }
};
