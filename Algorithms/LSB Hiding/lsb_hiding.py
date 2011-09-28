import wave         # Python rocks!
import struct
import sys

# Uses LSB hiding to embed a given set of watermark data
# into a specified cover audio
# Currently only supports WAV files
# cover_filepath is the path to a host WAV audio file 
# watermark is the data to be embedded (can be any type, only the binary representation is used)
# watermarked_output_path is the path for the watermarked audio data to be written to
def lsb_watermark(cover_filepath, watermark_data, watermarked_output_path):
    
    watermark_str = str(watermark_data)
    watermark = struct.unpack("%dB" % len(watermark_str), watermark_str)
    
    watermark_size = len(watermark)
    watermark_bits = watermark_to_bits((watermark_size,), 32)
    watermark_bits.extend(watermark_to_bits(watermark))
    
    cover_audio = wave.open(cover_filepath, 'rb') 
    
    (nchannels, sampwidth, framerate, nframes, comptype, compname) = cover_audio.getparams()
    frames = cover_audio.readframes (nframes * nchannels)
    samples = struct.unpack_from ("%dh" % nframes * nchannels, frames)

    if len(samples) < len(watermark_bits):
        raise OverflowError("The watermark data provided is too big to fit into the cover audio! Tried to fit %d bits into %d bits of space." % (len(watermark_bits), len(samples))) 
    
    print "Watermarking %s (%d samples) with %d bits of information." % (cover_filepath, len(samples), len(watermark_bits))
    
    encoded_samples = []
    
    watermark_position = 0
    n = 0
    for sample in samples:
        encoded_sample = sample
        
        if watermark_position < len(watermark_bits):
            encode_bit = watermark_bits[watermark_position]
            if encode_bit == 1:
                encoded_sample = sample | encode_bit
            else:
                encoded_sample = sample
                if sample & 1 != 0:
                    encoded_sample = sample - 1
                    
            watermark_position = watermark_position + 1
            
        encoded_samples.append(encoded_sample)
            
    encoded_audio = wave.open(watermarked_output_path, 'wb')
    encoded_audio.setparams( (nchannels, sampwidth, framerate, nframes, comptype, compname) )

    encoded_audio.writeframes(struct.pack("%dh" % len(encoded_samples), *encoded_samples))

def watermark_to_bits(watermark, nbits=8):
    watermark_bits = []
    for byte in watermark:
        for i in range(0,nbits):
            watermark_bits.append( (byte & (2 ** i)) >> i )
    return watermark_bits
    
def recover_lsb_watermark(watermarked_filepath):
    # Simply collect the LSB from each sample
    watermarked_audio = wave.open(watermarked_filepath, 'rb') 
    
    (nchannels, sampwidth, framerate, nframes, comptype, compname) = watermarked_audio.getparams()
    frames = watermarked_audio.readframes (nframes * nchannels)
    samples = struct.unpack_from ("%dh" % nframes * nchannels, frames)
    
    # determine how many watermark bytes we should look for
    watermark_bytes = 0
    for (sample,i) in zip(samples[0:32], range(0,32)):
        watermark_bytes = watermark_bytes + ( (sample & 1) * (2 ** i))
    
    print "Recovering %d bytes of watermark information from %s (%d samples)" % (watermark_bytes, watermarked_filepath, len(samples))
    
    watermark_data = []
    
    for n in range(0, watermark_bytes):
        watermark_byte_samples = samples[32 + (n * 8) : 32+((n+1) * 8)]
        watermark_byte = 0
        for (sample, i) in zip(watermark_byte_samples, range(0,8)):
            watermark_byte = watermark_byte + ( (sample & 1) * (2**i) )
        watermark_data.append(watermark_byte)
            
    return watermark_data
    
def watermark_to_string(list):
    return "".join([chr(x) for x in list])

def embed_file(cover_audio, hidden_file, output):
	f = open(hidden_file)
	hidden_data = f.read()
	lsb_watermark(cover_audio, hidden_data, output)

def recover_embedded_file(encoded_signal, hidden_data_dest):
	wm = recover_lsb_watermark(encoded_signal)
	wm_str = watermark_to_string(wm)
	f = open(hidden_data_dest,"w")
	f.write(wm_str)
    
if __name__ == "__main__":
    message = "this is an example of steganography in audio!"
    cover_audio = "../test_data/bach.wav"
    output = "w.wav"
    if len(sys.argv) > 1:
        message = sys.argv[1]
        if len(sys.argv) > 2:
            cover_audio = sys.argv[2]
            if len(sys.argv) > 3:
                output = sys.argv[3]
    lsb_watermark(cover_audio, message, output)
    
    recover_lsb_watermark(output)
