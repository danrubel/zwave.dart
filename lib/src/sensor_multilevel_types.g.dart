// Multilevel sensor type constants
// Import zwave/lib/message_consts.dart rather than directly importing this file

import 'package:zwave/src/sensor_multilevel_types.dart';

final sensorMultilevelTypes = [
  null, // Reserved
  /*  1 - 0x01 */ airTemperatureSensorMultilevelType,
  /*  2 - 0x02 */ generalPurposeSensorMultilevelType,
  /*  3 - 0x03 */ illuminanceSensorMultilevelType,
  /*  4 - 0x04 */ powerSensorMultilevelType,
  /*  5 - 0x05 */ humiditySensorMultilevelType,
  /*  6 - 0x06 */ velocitySensorMultilevelType,
  /*  7 - 0x07 */ directionSensorMultilevelType,
  /*  8 - 0x08 */ atmosphericPressureSensorMultilevelType,
  /*  9 - 0x09 */ barometricPressureSensorMultilevelType,
  /* 10 - 0x0A */ solarRadiationSensorMultilevelType,
  /* 11 - 0x0B */ dewPointSensorMultilevelType,
  /* 12 - 0x0C */ rainRateSensorMultilevelType,
  /* 13 - 0x0D */ tideLevelSensorMultilevelType,
  /* 14 - 0x0E */ weightSensorMultilevelType,
  /* 15 - 0x0F */ voltageSensorMultilevelType,
  /* 16 - 0x10 */ currentSensorMultilevelType,
  /* 17 - 0x11 */ carbonDioxideLevelSensorMultilevelType,
  /* 18 - 0x12 */ airFlowSensorMultilevelType,
  /* 19 - 0x13 */ tankCapacitySensorMultilevelType,
  /* 20 - 0x14 */ distanceSensorMultilevelType,
  /* 21 - 0x15 */ anglePositionSensorMultilevelType,
  /* 22 - 0x16 */ rotationSensorMultilevelType,
  /* 23 - 0x17 */ waterTemperatureSensorMultilevelType,
  /* 24 - 0x18 */ soilTemperatureSensorMultilevelType,
  /* 25 - 0x19 */ seismicIntensitySensorMultilevelType,
  /* 26 - 0x1A */ seismicMagnitudeSensorMultilevelType,
  /* 27 - 0x1B */ ultravioletSensorMultilevelType,
  /* 28 - 0x1C */ electricalResistivitySensorMultilevelType,
  /* 29 - 0x1D */ electricalConductivitySensorMultilevelType,
  /* 30 - 0x1E */ loudnessSensorMultilevelType,
  /* 31 - 0x1F */ moistureSensorMultilevelType,
  /* 32 - 0x20 */ frequencySensorMultilevelType,
  /* 33 - 0x21 */ timeSensorMultilevelType,
  /* 34 - 0x22 */ targetTemperatureSensorMultilevelType,
  /* 35 - 0x23 */ particulateMatterSensorMultilevelType,
  /* 36 - 0x24 */ formaldehydeLevelSensorMultilevelType,
  /* 37 - 0x25 */ radonConcentrationSensorMultilevelType,
  /* 38 - 0x26 */ methaneDensitySensorMultilevelType,
  /* 39 - 0x27 */ volatileOrganicCompoundLevelSensorMultilevelType,
  /* 40 - 0x28 */ carbonMonoxideLevelSensorMultilevelType,
  /* 41 - 0x29 */ soilHumiditySensorMultilevelType,
  /* 42 - 0x2A */ soilReactivitySensorMultilevelType,
  /* 43 - 0x2B */ soilSalinitySensorMultilevelType,
  /* 44 - 0x2C */ heartRateSensorMultilevelType,
  /* 45 - 0x2D */ bloodPressureSensorMultilevelType,
  /* 46 - 0x2E */ muscleMassSensorMultilevelType,
  /* 47 - 0x2F */ fatMassSensorMultilevelType,
  /* 48 - 0x30 */ boneMassSensorMultilevelType,
  /* 49 - 0x31 */ totalBodyWaterSensorMultilevelType,
  /* 50 - 0x32 */ basisMetabolicRateSensorMultilevelType,
  /* 51 - 0x33 */ bodyMassIndexSensorMultilevelType,
  /* 52 - 0x34 */ accelerationXAxisSensorMultilevelType,
  /* 53 - 0x35 */ accelerationYAxisSensorMultilevelType,
  /* 54 - 0x36 */ accelerationZAxisSensorMultilevelType,
  /* 55 - 0x37 */ smokeDensitySensorMultilevelType,
  /* 56 - 0x38 */ waterFlowSensorMultilevelType,
  /* 57 - 0x39 */ waterPressureSensorMultilevelType,
  /* 58 - 0x3A */ rfSignalStrengthSensorMultilevelType,
  /* 59 - 0x3B */ particulateMatter10SensorMultilevelType,
  /* 60 - 0x3C */ respiratoryRateSensorMultilevelType,
  /* 61 - 0x3D */ relativeModulationLevelSensorMultilevelType,
  /* 62 - 0x3E */ boilerWaterTemperatureSensorMultilevelType,
  /* 63 - 0x3F */ domesticHotWaterTemperatureSensorMultilevelType,
  /* 64 - 0x40 */ outsideTemperatureSensorMultilevelType,
  /* 65 - 0x41 */ exhaustTemperatureSensorMultilevelType,
  /* 66 - 0x42 */ waterChlorineLevelSensorMultilevelType,
  /* 67 - 0x43 */ waterAciditySensorMultilevelType,
  /* 68 - 0x44 */ waterOxidationReductionPotentialSensorMultilevelType,
  /* 69 - 0x45 */ heartRateRatioSensorMultilevelType,
  /* 70 - 0x46 */ motionDirectionSensorMultilevelType,
  /* 71 - 0x47 */ appliedForceOnTheSensorSensorMultilevelType,
  /* 72 - 0x48 */ returnAirTemperatureSensorMultilevelType,
  /* 73 - 0x49 */ supplyAirTemperatureSensorMultilevelType,
  /* 74 - 0x4A */ condenserCoilTemperatureSensorMultilevelType,
  /* 75 - 0x4B */ evaporatorCoilTemperatureSensorMultilevelType,
  /* 76 - 0x4C */ liquidLineTemperatureSensorMultilevelType,
  /* 77 - 0x4D */ dischargeLineTemperatureSensorMultilevelType,
  /* 78 - 0x4E */ suctionPressureSensorMultilevelType,
  /* 79 - 0x4F */ dischargePressureSensorMultilevelType,
  /* 80 - 0x50 */ defrostTemperatureSensorMultilevelType,
  /* 81 - 0x51 */ ozoneSensorMultilevelType,
  /* 82 - 0x52 */ sulfurDioxideSensorMultilevelType,
  /* 83 - 0x53 */ nitrogenDioxideSensorMultilevelType,
  /* 84 - 0x54 */ ammoniaSensorMultilevelType,
  /* 85 - 0x55 */ leadSensorMultilevelType,
  /* 86 - 0x56 */ particulateMatter1SensorMultilevelType,
  /* 87 - 0x57 */ personCounterEnteringSensorMultilevelType,
  /* 88 - 0x58 */ personCounterExitingSensorMultilevelType,
];

const accelerationXAxisSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 52,
  scaleTypeDescriptions: ['Meter per square second (m/s2)'],
  description: 'Acceleration X-axis',
);

const accelerationYAxisSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 53,
  scaleTypeDescriptions: ['Meter per square second (m/s2)'],
  description: 'Acceleration Y-axis',
);

const accelerationZAxisSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 54,
  scaleTypeDescriptions: ['Meter per square second (m/s2)'],
  description: 'Acceleration Z-axis',
);

const airFlowSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 18,
  scaleTypeDescriptions: [
    'Cubic meter per hour (m3/h)',
    'Cubic feet per minute (cfm)',
  ],
  description: 'Air flow',
);

const airTemperatureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 1,
  scaleTypeDescriptions: [
    'Celcius (C)',
    'Fahrenheit (F)',
  ],
  description: 'Air temperature',
);

const ammoniaSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 84,
  scaleTypeDescriptions: ['Micro gram per cubic meter (μg/m3)'],
  description: 'Ammonia (NH3)',
);

const anglePositionSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 21,
  scaleTypeDescriptions: [
    'Percentage value (%)',
    'Degrees relative to north pole of standing eye view',
    'Degrees relative to north pole of standing eye view',
  ],
  description: 'Angle position [DEPRECATED by V8]',
);

const appliedForceOnTheSensorSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 71,
  scaleTypeDescriptions: ['Newton (N)'],
  description: 'Applied force on the sensor',
);

const atmosphericPressureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 8,
  scaleTypeDescriptions: [
    'Kilopascal (kPa)',
    'Inches of Mercury',
  ],
  description: 'Atmospheric pressure',
);

const barometricPressureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 9,
  scaleTypeDescriptions: [
    'Kilopascal (kPa)',
    'Inches of Mercury',
  ],
  description: 'Barometric pressure',
);

const basisMetabolicRateSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 50,
  scaleTypeDescriptions: ['Joule (J)'],
  description: 'Basis metabolic rate (BMR)',
);

const bloodPressureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 45,
  scaleTypeDescriptions: [
    'Systolic (mmHg) (upper #)',
    'Diastolic (mmHg) (lower #)',
  ],
  description: 'Blood pressure',
);

const bodyMassIndexSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 51,
  scaleTypeDescriptions: ['BMI Index'],
  description: 'Body Mass Index (BMI)',
);

const boilerWaterTemperatureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 62,
  scaleTypeDescriptions: [
    'Celcius (C)',
    'Fahrenheit (F)',
  ],
  description: 'Boiler water temperature',
);

const boneMassSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 48,
  scaleTypeDescriptions: ['Kilogram (kg)'],
  description: 'Bone mass',
);

const carbonDioxideLevelSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 17,
  scaleTypeDescriptions: ['Parts/million (ppm)'],
  description: 'Carbon dioxide CO2-level',
);

const carbonMonoxideLevelSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 40,
  scaleTypeDescriptions: [
    'Mole per cubic meter (mol/m3)',
    'Parts/million (ppm)',
  ],
  description: 'Carbon monoxide (CO) level',
);

const condenserCoilTemperatureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 74,
  scaleTypeDescriptions: [
    'Celcius (C)',
    'Fahrenheit (F)',
  ],
  description: 'Condenser Coil temperature',
);

const currentSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 16,
  scaleTypeDescriptions: [
    'Ampere (A)',
    'Milliampere (mA)',
  ],
  description: 'Current',
);

const defrostTemperatureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 80,
  scaleTypeDescriptions: [
    'Celcius (C)',
    'Fahrenheit (F)',
  ],
  description: 'Defrost temperature (sensor used to decide when to defrost)',
);

const dewPointSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 11,
  scaleTypeDescriptions: [
    'Celcius (C)',
    'Fahrenheit (F)',
  ],
  description: 'Dew point',
);

const directionSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 7,
  scaleTypeDescriptions: [
    '0 to 360 degrees: 0 = no wind, 90 = east, 180 = south, 270 = west and 360 = north'
  ],
  description: 'Direction',
);

const dischargeLineTemperatureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 77,
  scaleTypeDescriptions: [
    'Celcius (C)',
    'Fahrenheit (F)',
  ],
  description: 'Discharge Line temperature',
);

const dischargePressureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 79,
  scaleTypeDescriptions: [
    'Kilopascal (kPa)',
    'Pound per square inch (psi)',
  ],
  description: 'Discharge (output pump/compressor) Pressure',
);

const distanceSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 20,
  scaleTypeDescriptions: [
    'Meter (m)',
    'Centimeter (cm)',
    'Feet (ft)',
  ],
  description: 'Distance',
);

const domesticHotWaterTemperatureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 63,
  scaleTypeDescriptions: [
    'Celcius (C)',
    'Fahrenheit (F)',
  ],
  description: 'Domestic Hot Water (DHW) temperature',
);

const electricalConductivitySensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 29,
  scaleTypeDescriptions: ['Siemens per meter (S/m)'],
  description: 'Electrical conductivity',
);

const electricalResistivitySensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 28,
  scaleTypeDescriptions: ['Ohm meter (Ωm)'],
  description: 'Electrical resistivity',
);

const evaporatorCoilTemperatureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 75,
  scaleTypeDescriptions: [
    'Celcius (C)',
    'Fahrenheit (F)',
  ],
  description: 'Evaporator Coil temperature',
);

const exhaustTemperatureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 65,
  scaleTypeDescriptions: [
    'Celcius (C)',
    'Fahrenheit (F)',
  ],
  description: 'Exhaust temperature',
);

const fatMassSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 47,
  scaleTypeDescriptions: ['Kilogram (kg)'],
  description: 'Fat mass',
);

const formaldehydeLevelSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 36,
  scaleTypeDescriptions: ['Mole per cubic meter (mol/m3)'],
  description: 'Formaldehyde CH2O-level',
);

const frequencySensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 32,
  scaleTypeDescriptions: [
    'Hertz (Hz)',
    'kilohertz (kHz)',
  ],
  description: 'Frequency',
);

const generalPurposeSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 2,
  scaleTypeDescriptions: [
    'Percentage value (%)',
    'Dimensionless value',
  ],
  description: 'General purpose [DEPRECATED by V11]',
);

const heartRateRatioSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 69,
  scaleTypeDescriptions: ['Unitless'],
  description: 'Heart Rate LF/HF ratio',
);

const heartRateSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 44,
  scaleTypeDescriptions: ['Beats per minute (bpm)'],
  description: 'Heart rate',
);

const humiditySensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 5,
  scaleTypeDescriptions: [
    'Percentage value (%)',
    'Absolute humidity (g/m3)',
  ],
  description: 'Humidity',
);

const illuminanceSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 3,
  scaleTypeDescriptions: [
    'Percentage value (%)',
    'Lux',
  ],
  description: 'Illuminance',
);

const leadSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 85,
  scaleTypeDescriptions: ['Micro gram per cubic meter (μg/m3)'],
  description: 'Lead (Pb)',
);

const liquidLineTemperatureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 76,
  scaleTypeDescriptions: [
    'Celcius (C)',
    'Fahrenheit (F)',
  ],
  description: 'Liquid Line temperature',
);

const loudnessSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 30,
  scaleTypeDescriptions: [
    'Decibel (dB)',
    'A-weighted decibels (dBA)',
  ],
  description: 'Loudness',
);

const methaneDensitySensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 38,
  scaleTypeDescriptions: ['Mole per cubic meter (mol/m3)'],
  description: 'Methane (CH4) density',
);

const moistureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 31,
  scaleTypeDescriptions: [
    'Percentage value (%)',
    'Volume water content (m3/m3)',
    'Impedance (kΩ)',
    'Water activity (aw)',
  ],
  description: 'Moisture',
);

const motionDirectionSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 70,
  scaleTypeDescriptions: [
    '0 to 360 degrees: 0 = no motion detected, 90 = east, 180 = south, 270 = west and 360 = north'
  ],
  description: 'Motion Direction',
);

const muscleMassSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 46,
  scaleTypeDescriptions: ['Kilogram (kg)'],
  description: 'Muscle mass',
);

const nitrogenDioxideSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 83,
  scaleTypeDescriptions: ['Micro gram per cubic meter (μg/m3)'],
  description: 'Nitrogen dioxide (NO2)',
);

const outsideTemperatureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 64,
  scaleTypeDescriptions: [
    'Celcius (C)',
    'Fahrenheit (F)',
  ],
  description: 'Outside temperature',
);

const ozoneSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 81,
  scaleTypeDescriptions: ['Micro gram per cubic meter (μg/m3)'],
  description: 'Ozone (O3)',
);

const particulateMatter10SensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 59,
  scaleTypeDescriptions: [
    'Mole per cubic meter (mol/m3)',
    'Microgram per cubic meter (µg/m3)',
  ],
  description: 'Particulate Matter 10',
);

const particulateMatter1SensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 86,
  scaleTypeDescriptions: ['Micro gram per cubic meter (μg/m3)'],
  description: 'Particulate Matter 1',
);

const particulateMatterSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 35,
  scaleTypeDescriptions: [
    'Mole per cubic meter (mol/m3)',
    'Microgram per cubic meter (µg/m3)',
  ],
  description: 'Particulate Matter 2.5',
);

const personCounterEnteringSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 87,
  scaleTypeDescriptions: ['Unitless'],
  description: 'Person counter (entering)',
);

const personCounterExitingSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 88,
  scaleTypeDescriptions: ['Unitless'],
  description: 'Person counter (exiting)',
);

const powerSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 4,
  scaleTypeDescriptions: [
    'Watt (W)',
    'Btu/h',
  ],
  description: 'Power',
);

const radonConcentrationSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 37,
  scaleTypeDescriptions: [
    'Becquerel per cubic meter (bq/m3)',
    'Picocuries per liter (pCi/l)',
  ],
  description: 'Radon concentration',
);

const rainRateSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 12,
  scaleTypeDescriptions: [
    'Millimeter/hour (mm/h)',
    'Inches per hour (in/h)',
  ],
  description: 'Rain rate',
);

const relativeModulationLevelSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 61,
  scaleTypeDescriptions: ['Percentage value (%)'],
  description: 'Relative Modulation level',
);

const respiratoryRateSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 60,
  scaleTypeDescriptions: ['Breaths per minute (bpm)'],
  description: 'Respiratory rate',
);

const returnAirTemperatureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 72,
  scaleTypeDescriptions: [
    'Celcius (C)',
    'Fahrenheit (F)',
  ],
  description: 'Return Air temperature',
);

const rfSignalStrengthSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 58,
  scaleTypeDescriptions: [
    'RSSI (percentage value)',
    'dBm',
  ],
  description: 'RF signal strength',
);

const rotationSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 22,
  scaleTypeDescriptions: [
    'Revolutions per minute (rpm)',
    'Hertz (Hz)',
  ],
  description: 'Rotation',
);

const seismicIntensitySensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 25,
  scaleTypeDescriptions: [
    'Mercalli',
    'European Macroseismic',
    'Liedu',
    'Shindo',
  ],
  description: 'Seismic Intensity',
);

const seismicMagnitudeSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 26,
  scaleTypeDescriptions: [
    'Local',
    'Moment',
    'Surface wave',
    'Body wave',
  ],
  description: 'Seismic magnitude',
);

const smokeDensitySensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 55,
  scaleTypeDescriptions: ['Percentage value (%)'],
  description: 'Smoke density',
);

const soilHumiditySensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 41,
  scaleTypeDescriptions: ['Percentage value (%)'],
  description: 'Soil humidity',
);

const soilReactivitySensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 42,
  scaleTypeDescriptions: ['Acidity (pH)'],
  description: 'Soil reactivity',
);

const soilSalinitySensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 43,
  scaleTypeDescriptions: ['Mole per cubic meter (mol/m3)'],
  description: 'Soil salinity',
);

const soilTemperatureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 24,
  scaleTypeDescriptions: [
    'Celcius (C)',
    'Fahrenheit (F)',
  ],
  description: 'Soil temperature',
);

const solarRadiationSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 10,
  scaleTypeDescriptions: ['Watt per square meter (W/m2)'],
  description: 'Solar radiation',
);

const suctionPressureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 78,
  scaleTypeDescriptions: [
    'Kilopascal (kPa)',
    'Pound per square inch (psi)',
  ],
  description: 'Suction (input pump/compressor) Pressure',
);

const sulfurDioxideSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 82,
  scaleTypeDescriptions: ['Micro gram per cubic meter (μg/m3)'],
  description: 'Sulfur dioxide (SO2)',
);

const supplyAirTemperatureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 73,
  scaleTypeDescriptions: [
    'Celcius (C)',
    'Fahrenheit (F)',
  ],
  description: 'Supply Air temperature',
);

const tankCapacitySensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 19,
  scaleTypeDescriptions: [
    'Liter (l)',
    'Cubic meter (m3)',
    'Gallons',
  ],
  description: 'Tank capacity',
);

const targetTemperatureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 34,
  scaleTypeDescriptions: [
    'Celcius (C)',
    'Fahrenheit (F)',
  ],
  description: 'Target temperature',
);

const tideLevelSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 13,
  scaleTypeDescriptions: [
    'Meter (m)',
    'Feet (ft)',
  ],
  description: 'Tide level',
);

const timeSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 33,
  scaleTypeDescriptions: ['Second (s)'],
  description: 'Time',
);

const totalBodyWaterSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 49,
  scaleTypeDescriptions: ['Kilogram (kg)'],
  description: 'Total body water (TBW)',
);

const ultravioletSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 27,
  scaleTypeDescriptions: ['UV index'],
  description: 'Ultraviolet',
);

const velocitySensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 6,
  scaleTypeDescriptions: [
    'm/s',
    'Mph',
  ],
  description: 'Velocity',
);

const volatileOrganicCompoundLevelSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 39,
  scaleTypeDescriptions: [
    'Mole per cubic meter (mol/m3)',
    'Parts/million (ppm)',
  ],
  description: 'Volatile Organic Compound level',
);

const voltageSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 15,
  scaleTypeDescriptions: [
    'Volt (V)',
    'Millivolt (mV)',
  ],
  description: 'Voltage',
);

const waterAciditySensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 67,
  scaleTypeDescriptions: ['Acidity (pH)'],
  description: 'Water acidity',
);

const waterChlorineLevelSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 66,
  scaleTypeDescriptions: ['Milligram per liter (mg/l)'],
  description: 'Water Chlorine level',
);

const waterFlowSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 56,
  scaleTypeDescriptions: ['Liter per hour (l/h)'],
  description: 'Water flow',
);

const waterOxidationReductionPotentialSensorMultilevelType =
    SensorMultilevelType(
  sensorTypeNum: 68,
  scaleTypeDescriptions: ['MilliVolt (mV)'],
  description: 'Water Oxidation reduction potential',
);

const waterPressureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 57,
  scaleTypeDescriptions: ['Kilopascal (kPa)'],
  description: 'Water pressure',
);

const waterTemperatureSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 23,
  scaleTypeDescriptions: [
    'Celcius (C)',
    'Fahrenheit (F)',
  ],
  description: 'Water temperature',
);

const weightSensorMultilevelType = SensorMultilevelType(
  sensorTypeNum: 14,
  scaleTypeDescriptions: [
    'Kilogram (kg)',
    'Pounds (lb)',
  ],
  description: 'Weight',
);
