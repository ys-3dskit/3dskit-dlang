/**
 * @file csnd.h
 * @brief CSND service. Usage of this service is deprecated in favor of NDSP.
 */

import ys3ds.ctru._3ds.types;

extern (C) @nogc nothrow:

/// Maximum number of CSND channels.
enum CSND_NUM_CHANNELS = 32;

/// Creates a CSND timer value from a sample rate.
extern (D) auto CSND_TIMER(T)(auto ref T n)
{
    return 0x3FEC3FC / (cast(uint) n);
}

/**
 * @brief Converts a vol-pan pair into a left/right volume pair used by the hardware.
 * @param vol Volume to use.
 * @param pan Pan to use.
 * @return A left/right volume pair for use by hardware.
 */
extern(D) uint CSND_VOL (float vol, float pan)
{
  float rpan;
  uint lvol, rvol;

  if (vol < 0.0f) vol = 0.0f;
  else if (vol > 1.0f) vol = 1.0f;

  rpan = (pan+1) / 2;
  if (rpan < 0.0f) rpan = 0.0f;
  else if (rpan > 1.0f) rpan = 1.0f;

  lvol = cast(uint) (vol * (1-rpan) * 0x8000);
  rvol = cast(uint) (vol * rpan * 0x8000);

  return lvol | (rvol << 16);
}

/// CSND encodings.
enum
{
    CSND_ENCODING_PCM8 = 0, ///< PCM8
    CSND_ENCODING_PCM16 = 1, ///< PCM16
    CSND_ENCODING_ADPCM = 2, ///< IMA-ADPCM
    CSND_ENCODING_PSG = 3 ///< PSG (Similar to DS?)
}

/// CSND loop modes.
enum
{
    CSND_LOOPMODE_MANUAL = 0, ///< Manual loop.
    CSND_LOOPMODE_NORMAL = 1, ///< Normal loop.
    CSND_LOOPMODE_ONESHOT = 2, ///< Do not loop.
    CSND_LOOPMODE_NORELOAD = 3 ///< Don't reload.
}

/// Creates a sound channel value from a channel number.
extern (D) auto SOUND_CHANNEL(T)(auto ref T n)
{
    return cast(uint) n & 0x1F;
}

/// Creates a sound format value from an encoding.
extern (D) auto SOUND_FORMAT(T)(auto ref T n)
{
    return cast(uint) n << 12;
}

/// Creates a sound loop mode value from a loop mode.
extern (D) auto SOUND_LOOPMODE(T)(auto ref T n)
{
    return cast(uint) n << 10;
}

/// Sound flags.
enum
{
    SOUND_LINEAR_INTERP = BIT(6), ///< Linear interpolation.
    SOUND_REPEAT = SOUND_LOOPMODE(.CSND_LOOPMODE_NORMAL), ///< Repeat the sound.
    SOUND_ONE_SHOT = SOUND_LOOPMODE(.CSND_LOOPMODE_ONESHOT), ///< Play the sound once.
    SOUND_FORMAT_8BIT = SOUND_FORMAT(.CSND_ENCODING_PCM8), ///< PCM8
    SOUND_FORMAT_16BIT = SOUND_FORMAT(.CSND_ENCODING_PCM16), ///< PCM16
    SOUND_FORMAT_ADPCM = SOUND_FORMAT(.CSND_ENCODING_ADPCM), ///< ADPCM
    SOUND_FORMAT_PSG = SOUND_FORMAT(.CSND_ENCODING_PSG), ///< PSG
    SOUND_ENABLE = BIT(14) ///< Enable sound.
}

/// Capture modes.
enum
{
    CAPTURE_REPEAT = 0, ///< Repeat capture.
    CAPTURE_ONE_SHOT = BIT(0), ///< Capture once.
    CAPTURE_FORMAT_16BIT = 0, ///< PCM16
    CAPTURE_FORMAT_8BIT = BIT(1), ///< PCM8
    CAPTURE_ENABLE = BIT(15) ///< Enable capture.
}

/// Duty cycles for a PSG channel.
enum CSND_DutyCycle
{
    DutyCycle_0 = 7, ///< 0.0% duty cycle
    DutyCycle_12 = 0, ///< 12.5% duty cycle
    DutyCycle_25 = 1, ///< 25.0% duty cycle
    DutyCycle_37 = 2, ///< 37.5% duty cycle
    DutyCycle_50 = 3, ///< 50.0% duty cycle
    DutyCycle_62 = 4, ///< 62.5% duty cycle
    DutyCycle_75 = 5, ///< 75.0% duty cycle
    DutyCycle_87 = 6 ///< 87.5% duty cycle
}

/// Channel info.
union CSND_ChnInfo
{
    uint[3] value; ///< Raw values.
    struct
    {
        ubyte active; ///< Channel active.
        ubyte _pad1; ///< Padding.
        ushort _pad2; ///< Padding.
        short adpcmSample; ///< Current ADPCM sample.
        ubyte adpcmIndex; ///< Current ADPCM index.
        ubyte _pad3; ///< Padding.
        uint unknownZero; ///< Unknown.
    }
}

/// Capture info.
union CSND_CapInfo
{
    uint[2] value; ///< Raw values.
    struct
    {
        ubyte active; ///< Capture active.
        ubyte _pad1; ///< Padding.
        ushort _pad2; ///< Padding.
        uint unknownZero; ///< Unknown.
    }
}

// See here regarding CSND shared-mem commands, etc: http://3dbrew.org/wiki/CSND_Shared_Memory

extern __gshared vu32* csndSharedMem; ///< CSND shared memory.
extern __gshared uint csndSharedMemSize; ///< CSND shared memory size.
extern __gshared uint csndChannels; ///< Bitmask of channels that are allowed for usage.

/**
 * @brief Acquires a capture unit.
 * @param capUnit Pointer to output the capture unit to.
 */
Result CSND_AcquireCapUnit (uint* capUnit);

/**
 * @brief Releases a capture unit.
 * @param capUnit Capture unit to release.
 */
Result CSND_ReleaseCapUnit (uint capUnit);

/**
 * @brief Flushes the data cache of a memory region.
 * @param adr Address of the memory region.
 * @param size Size of the memory region.
 */
Result CSND_FlushDataCache (const(void)* adr, uint size);

/**
 * @brief Stores the data cache of a memory region.
 * @param adr Address of the memory region.
 * @param size Size of the memory region.
 */
Result CSND_StoreDataCache (const(void)* adr, uint size);

/**
 * @brief Invalidates the data cache of a memory region.
 * @param adr Address of the memory region.
 * @param size Size of the memory region.
 */
Result CSND_InvalidateDataCache (const(void)* adr, uint size);

/**
 * @brief Resets CSND.
 * Note: Currently breaks sound, don't use for now!
 */
Result CSND_Reset ();

/// Initializes CSND.
Result csndInit ();

/// Exits CSND.
void csndExit ();

/**
 * @brief Adds a command to the list, returning a buffer to write arguments to.
 * @param cmdid ID of the command to add.
 * @return A buffer to write command arguments to.
 */
uint* csndAddCmd (int cmdid);

/**
 * @brief Adds a command to the list, copying its arguments from a buffer.
 * @param cmdid ID of the command to add.
 * @param cmdparams Buffer containing the command's parameters.
 */
void csndWriteCmd (int cmdid, ubyte* cmdparams);

/**
 * @brief Executes pending CSND commands.
 * @param waitDone Whether to wait until the commands have finished executing.
 */
Result csndExecCmds (bool waitDone);

/**
 * @brief Sets a channel's play state, resetting registers on stop.
 * @param channel Channel to use.
 * @param value Play state to set.
 */
void CSND_SetPlayStateR (uint channel, uint value);

/**
 * @brief Sets a channel's play state.
 * @param channel Channel to use.
 * @param value Play state to set.
 */
void CSND_SetPlayState (uint channel, uint value);

/**
 * @brief Sets a channel's encoding.
 * @param channel Channel to use.
 * @param value Encoding to set.
 */
void CSND_SetEncoding (uint channel, uint value);

/**
 * @brief Sets the data of a channel's block.
 * @param channel Channel to use.
 * @param block Block to set.
 * @param physaddr Physical address to set the block to.
 * @param size Size of the block.
 */
void CSND_SetBlock (uint channel, int block, uint physaddr, uint size);

/**
 * @brief Sets whether to loop a channel.
 * @param channel Channel to use.
 * @param value Whether to loop the channel.
 */
void CSND_SetLooping (uint channel, uint value);

/**
 * @brief Sets bit 7 of a channel.
 * @param channel Channel to use.
 * @param set Value to set.
 */
void CSND_SetBit7 (uint channel, bool set);

/**
 * @brief Sets whether a channel should use interpolation.
 * @param channel Channel to use.
 * @param interp Whether to use interpolation.
 */
void CSND_SetInterp (uint channel, bool interp);

/**
 * @brief Sets a channel's duty.
 * @param channel Channel to use.
 * @param duty Duty to set.
 */
void CSND_SetDuty (uint channel, CSND_DutyCycle duty);

/**
 * @brief Sets a channel's timer.
 * @param channel Channel to use.
 * @param timer Timer to set.
 */
void CSND_SetTimer (uint channel, uint timer);

/**
 * @brief Sets a channel's volume.
 * @param channel Channel to use.
 * @param chnVolumes Channel volume data to set.
 * @param capVolumes Capture volume data to set.
 */
void CSND_SetVol (uint channel, uint chnVolumes, uint capVolumes);

/**
 * @brief Sets a channel's ADPCM state.
 * @param channel Channel to use.
 * @param block Current block.
 * @param sample Current sample.
 * @param index Current index.
 */
void CSND_SetAdpcmState (uint channel, int block, int sample, int index);

/**
 * @brief Sets a whether channel's ADPCM data should be reloaded when the second block is played.
 * @param channel Channel to use.
 * @param reload Whether to reload ADPCM data.
 */
void CSND_SetAdpcmReload (uint channel, bool reload);

/**
 * @brief Sets CSND's channel registers.
 * @param flags Flags to set.
 * @param physaddr0 Physical address of the first buffer to play.
 * @param physaddr1 Physical address of the second buffer to play.
 * @param totalbytesize Total size of the data to play.
 * @param chnVolumes Channel volume data.
 * @param capVolumes Capture volume data.
 */
void CSND_SetChnRegs (uint flags, uint physaddr0, uint physaddr1, uint totalbytesize, uint chnVolumes, uint capVolumes);

/**
 * @brief Sets CSND's PSG channel registers.
 * @param flags Flags to set.
 * @param chnVolumes Channel volume data.
 * @param capVolumes Capture volume data.
 * @param duty Duty value to set.
 */
void CSND_SetChnRegsPSG (uint flags, uint chnVolumes, uint capVolumes, CSND_DutyCycle duty);

/**
 * @brief Sets CSND's noise channel registers.
 * @param flags Flags to set.
 * @param chnVolumes Channel volume data.
 * @param capVolumes Capture volume data.
 */
void CSND_SetChnRegsNoise (uint flags, uint chnVolumes, uint capVolumes);

/**
 * @brief Sets whether a capture unit is enabled.
 * @param capUnit Capture unit to use.
 * @param enable Whether to enable the capture unit.
 */
void CSND_CapEnable (uint capUnit, bool enable);

/**
 * @brief Sets whether a capture unit should repeat.
 * @param capUnit Capture unit to use.
 * @param repeat Whether the capture unit should repeat.
 */
void CSND_CapSetRepeat (uint capUnit, bool repeat);

/**
 * @brief Sets a capture unit's format.
 * @param capUnit Capture unit to use.
 * @param eightbit Format to use.
 */
void CSND_CapSetFormat (uint capUnit, bool eightbit);

/**
 * @brief Sets a capture unit's second bit.
 * @param capUnit Capture unit to use.
 * @param set Value to set.
 */
void CSND_CapSetBit2 (uint capUnit, bool set);

/**
 * @brief Sets a capture unit's timer.
 * @param capUnit Capture unit to use.
 * @param timer Timer to set.
 */
void CSND_CapSetTimer (uint capUnit, uint timer);

/**
 * @brief Sets a capture unit's buffer.
 * @param capUnit Capture unit to use.
 * @param addr Buffer address to use.
 * @param size Size of the buffer.
 */
void CSND_CapSetBuffer (uint capUnit, uint addr, uint size);

/**
 * @brief Sets a capture unit's capture registers.
 * @param capUnit Capture unit to use.
 * @param flags Capture unit flags.
 * @param addr Capture unit buffer address.
 * @param size Buffer size.
 */
void CSND_SetCapRegs (uint capUnit, uint flags, uint addr, uint size);

/**
 * @brief Sets up DSP flags.
 * @param waitDone Whether to wait for completion.
 */
Result CSND_SetDspFlags (bool waitDone);

/**
 * @brief Updates CSND information.
 * @param waitDone Whether to wait for completion.
 */
Result CSND_UpdateInfo (bool waitDone);

/**
 * @brief Plays a sound.
 * @param chn Channel to play the sound on.
 * @param flags Flags containing information about the sound.
 * @param sampleRate Sample rate of the sound.
 * @param vol The volume, ranges from 0.0 to 1.0 included.
 * @param pan The pan, ranges from -1.0 to 1.0 included.
 * @param data0 First block of sound data.
 * @param data1 Second block of sound data. This is the block that will be looped over.
 * @param size Size of the sound data.
 *
 * In this implementation if the loop mode is used, data1 must be in the range [data0 ; data0 + size]. Sound will be played once from data0 to data0 + size and then loop between data1 and data0+size.
 */
Result csndPlaySound (int chn, uint flags, uint sampleRate, float vol, float pan, void* data0, void* data1, uint size);

/**
 * @brief Gets CSND's DSP flags.
 * Note: Requires previous CSND_UpdateInfo()
 * @param outSemFlags Pointer to write semaphore flags to.
 * @param outIrqFlags Pointer to write interrupt flags to.
 */
void csndGetDspFlags (uint* outSemFlags, uint* outIrqFlags);

/**
 * @brief Gets a channel's information.
 * Note: Requires previous CSND_UpdateInfo()
 * @param channel Channel to get information for.
 * @return The channel's information.
 */
CSND_ChnInfo* csndGetChnInfo (uint channel);

/**
 * @brief Gets a capture unit's information.
 * Note: Requires previous CSND_UpdateInfo()
 * @param capUnit Capture unit to get information for.
 * @return The capture unit's information.
 */
CSND_CapInfo* csndGetCapInfo (uint capUnit);

/**
 * @brief Gets a channel's state.
 * @param channel Channel to get the state of.
 * @param out Pointer to output channel information to.
 */
Result csndGetState (uint channel, CSND_ChnInfo* out_);

/**
 * @brief Gets whether a channel is playing.
 * @param channel Channel to check.
 * @param status Pointer to output the channel status to.
 */
Result csndIsPlaying (uint channel, ubyte* status);
