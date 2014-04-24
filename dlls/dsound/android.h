#ifndef DSOUND_ANDROID
#define DSOUND_ANDROID

/**
 * ���� PCM
 * ����������� ������ ��������������� ������������ com.eltechs.axs.soundServer.ClientFormats
 */
typedef enum
{
    ANDROID_TYPE_U8,
    ANDROID_TYPE_S16LE,
    ANDROID_TYPE_S16BE,
    ANDROID_TYPE_S32LE,
    ANDROID_TYPE_S32BE,
    ANDROID_TYPE_FLOATLE,
    ANDROID_TYPE_FLOATBE
} snd_pcm_android_types_t;

/* ���������� ���������, ����� ������� ����� �������� ����, �� ������� ������� �������� ������ AXS. */
#define ANDROID_SOUND_SERVER_PORT_ARGUMENT_NAME ("AXS_SOUND_SERVER_PORT")

/**
 * ������� ��������� �������
 */
typedef enum
{
    ANDROID_OPC_close = 0,
    ANDROID_OPC_prepare = 1,
    ANDROID_OPC_start = 2,
    ANDROID_OPC_write = 3,
    ANDROID_OPC_stop = 4,
    ANDROID_OPC_pointer = 5,
    ANDROID_OPC_drain = 6
} snd_pcm_android_opc_t;

/**
 * ������� prepare
 */
typedef struct
{
    int opc;
    int len;
    int type;
    int channels;
    int rate;
} snd_pcm_android_cmd_prepare_t;

/**
 * ����������� �������, ��������� �� ���������
 */
typedef struct
{
    int opc;
    int len;
} snd_pcm_android_cmd_trivial_t;

typedef snd_pcm_android_cmd_trivial_t snd_pcm_android_cmd_write_t;
typedef snd_pcm_android_cmd_trivial_t snd_pcm_android_cmd_close_t;
typedef snd_pcm_android_cmd_trivial_t snd_pcm_android_cmd_start_t;
typedef snd_pcm_android_cmd_trivial_t snd_pcm_android_cmd_stop_t;
typedef snd_pcm_android_cmd_trivial_t snd_pcm_android_cmd_pointer_t;
typedef snd_pcm_android_cmd_trivial_t snd_pcm_android_cmd_drain_t;

/**
 * ���������� ������ �������, �� ������� ���������
 */
#define SIZE_OF_RAW_CMD( type ) (sizeof(type) - sizeof(int)*2)

/**
 * ������� ��������� ������� ������̣����� ����
 */
#define DEFINE_CMD( type ) \
    snd_pcm_android_cmd_##type##_t cmd; \
    cmd.opc = ANDROID_OPC_##type; \
    cmd.len = SIZE_OF_RAW_CMD( snd_pcm_android_cmd_##type##_t );

#endif /* DSOUND_ANDROID */
