// automatically generated by admSerialization.py do not edit
#ifndef ADM_xvid4_encoder_CONF_H
#define ADM_xvid4_encoder_CONF_H
typedef struct {
COMPRES_PARAMS params;
uint32_t profile;
uint32_t rdMode;
uint32_t motionEstimation;
uint32_t cqmMode;
uint32_t arMode;
uint32_t maxBFrame;
uint32_t maxKeyFrameInterval;
uint32_t nbThreads;
uint32_t qMin;
uint32_t qMax;
bool rdOnBFrame;
bool hqAcPred;
bool optimizeChrome;
bool trellis;
}xvid4_encoder;
#endif
