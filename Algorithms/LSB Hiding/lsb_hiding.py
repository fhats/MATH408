import wave         # Python rocks!
import sys

# Uses LSB hiding to embed a given set of watermark data
# into a specified cover audio
# Currently only supports WAV files
# cover_filepath is the path to a host WAV audio file 
# watermark is the data to be embedded (can be any type, only the binary representation is used)
# watermarked_output_path is the path for the watermarked audio data to be written to
def lsb_watermark(cover_filepath, watermark, watermarked_output_path):
    watermark_end_signal = 0xBEEFBABE
    watermark_length = sys.getsizeof(watermark)
    
    cover_audio = wave.open(cover_filepath, 'rb') 
    output = wave.open(watermarked_output_path, 'wb')
    
    n = 0
    watermark_position = 0
    while n < cover_audio.getnframes():
        current_sample = cover_audio.readframes(1)
        
        if watermark_position > watermark_length:
            
        
        watermark_position = watermark_position + 1
        n = n + 1
    
if __name__ == "__main__":
    lsb_watermark("../test_data/bach.wav", "excellent", "w.wav")