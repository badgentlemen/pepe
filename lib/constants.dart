import 'package:flutter/material.dart';
import 'package:pepe/models/random_range.dart';

const disappearingAmount = 7;
const disappearingStepTime = 1 / disappearingAmount;
const defaultSunPower = 250;
const defaultElectricity = 250;
const defaultLevelDuration = Duration(minutes: 2, seconds: 30);

const defaultCloudRandomRange = RandomRange(less: .3, over: .75);
const defaultPestValue = 60;
const defaultDamage = 20;
const defaultHealth = 100;
const defaultPower = 100;
const systemPowerPerFrequency = 1;
const int defaultPlantPrice = 150;
const double cloudFrequency = 8;
const double defaultSpeed = 1;
const double bulletRadius = 8;

const blockSizeImpl = 23;
const int fieldRows = 7;
const int fieldColumns = 18;
const int solarPanels = 3;
const int windTurbines = 3;

const int fenceVertCount = 13;
const int fenceHorCount = 3;

const electricityColor = Color.fromARGB(255, 33, 61, 243);
const sunPowerColor = Color.fromRGBO(255, 167, 38, 1);

const bulletFps = 14;
const pestFps = 0.1;

const cardsRatio = 170 / 220;

const fieldAssetRatio = 1025 / 272;
const airplaneAssetRatio = 407 / 267;
const cloudAssetRatio = 958 / 641;
const carrotAssetRatio = 580 / 539;
const cornAssetRatio = 2479 / 3200;
const watermelonAssetRatio = 641 / 632;
const generatorAssetRatio = 681 / 801;
const windTurbineAssetRatio = 716 / 2400;
const boltAssetRatio = 601 / 708;