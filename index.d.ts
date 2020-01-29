declare module "react-native-sensors" {
  import { Observable } from "rxjs";

  type Sensors = {
    accelerometer: "accelerometer";
    gyroscope: "gyroscope";
    deviceMotion: "deviceMotion";
    magnetometer: "magnetometer";
    barometer: "barometer";
  };

  export const SensorTypes: Sensors;

  export const setUpdateIntervalForType: (
    type: keyof Sensors,
    updateInterval: number
  ) => void;

  interface SensorData {
    x: number;
    y: number;
    z: number;
    timestamp: string;
  }

  interface MotionData {
    x: number;
    y: number;
    z: number;
  }

  interface BarometerData {
    pressure: number;
  }

  type SensorsBase = {
    accelerometer: Observable<SensorData>;
    gyroscope: Observable<SensorData>;
    deviceMotion: Observable<MotionData>;
    magnetometer: Observable<SensorData>;
    barometer: Observable<BarometerData>;
  };

  export const {
    accelerometer,
    gyroscope,
    deviceMotion,
    magnetometer,
    barometer
  }: SensorsBase;

  const sensors: SensorsBase;

  export default sensors;
}
