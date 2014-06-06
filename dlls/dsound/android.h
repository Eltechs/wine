#ifndef DSOUND_ANDROID
#define DSOUND_ANDROID

#include <inttypes.h>

/* ���������, ������� ������ ���� � ������ ������, ������������� ������� ��������� direct sound. */
#define DSOUND_ANDROID_SHMEM_BUFFER_MAGIC (((unsigned)'D' << 0) | ((unsigned)'S' << 8) | ((unsigned)'N' << 16) | ((unsigned)'D' << 24))

/* ���������� ���������, ����� ������� ����� �������� ����, �� ������� ������� ������ ��������� direct sound. */
#define ANDROID_DSOUND_SERVER_PORT_ARGUMENT_NAME ("AXS_DSOUND_SERVER_PORT")

/**
 * ����� �� ��������� �������, ������� ���������� ������� ��������� direct sound.
 */
typedef struct
{
    uint32_t magic;
    uint16_t n_channels;
    uint16_t bits_per_sample;
    uint32_t sample_rate;
    uint32_t n_samples;
    volatile uint32_t current_pos;

    uint32_t padding[11];

    uint8_t data[0];
} dsound_shmem_buffer_t;

/**
 * ������� ��������� �������. �������� ������������ ������ ���� ���������������� � ����������� ��
 * com.eltechs.axs.dsoundServer.Opcodes.
 */
typedef enum
{
    ANDROID_OPC_attach = 0,

    ANDROID_OPC_play = 1,
    ANDROID_OPC_stop = 2,
    ANDROID_OPC_set_current_position = 3,
} dsound_android_opc_t;

/**
 * ������� Attach
 */
typedef struct
{
    int opc;
    int len;
    int shmid;
} dsound_android_cmd_attach_t;

/**
 * ������� Play.
 */
typedef struct
{
    int opc;
    int len;
    int flags;
} dsound_android_cmd_play_t;

/**
 * ������� SetCurrentPosition.
 */
typedef struct
{
    int opc;
    int len;
    int position;
} dsound_android_cmd_set_current_position_t;

/**
 * ����������� �������, ��������� �� ���������
 */
typedef struct
{
    int opc;
    int len;
} dsound_android_cmd_trivial_t;

typedef dsound_android_cmd_trivial_t dsound_android_cmd_stop_t;

/**
 * ���������� ������ �������, �� ������� ���������
 */
#define SIZE_OF_RAW_CMD( type ) (sizeof(type) - sizeof(int)*2)

/**
 * ������� ��������� ������� ������̣����� ����
 */
#define DEFINE_CMD( type ) \
    dsound_android_cmd_##type##_t cmd; \
    cmd.opc = ANDROID_OPC_##type; \
    cmd.len = SIZE_OF_RAW_CMD( dsound_android_cmd_##type##_t );

#define SEND_DSOUND_ANDROID_CMD() \
    do { \
        int response; \
        \
        write(This->android_socket, &cmd, sizeof(cmd)); \
        if ( sizeof(int) != read(This->android_socket, &response, sizeof(response)) ) { \
            ERR("SEND_DSOUND_ANDROID_CMD(op = %d) has failed\n", cmd.opc); \
            abort(); \
        } \
        if ( response != 0 ) { \
            ERR("SEND_DSOUND_ANDROID_CMD(op = %d) has failed\n", cmd.opc); \
            abort(); \
        } \
    } while (0)

#endif /* DSOUND_ANDROID */
