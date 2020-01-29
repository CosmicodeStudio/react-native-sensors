import sensors from "./src/sensors";
export { setUpdateInterval as setUpdateIntervalForType } from "./src/rnsensors";

export const SensorTypes = {
  accelerometer: "accelerometer",
  gyroscope: "gyroscope",
  magnetometer: "magnetometer",
  barometer: "barometer",
  devicemotion: "devicemotion"
};

export const { accelerometer, gyroscope, magnetometer, barometer, devicemotion } = sensors;
export default sensors;
