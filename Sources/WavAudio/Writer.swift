
import Foundation
import AVFoundation
import OSLog


// create a PCM buffer from a float array and write it to a wav file
// errors are suppressed and logged

class Writer {
  
  let log = Logger()
  
  public func buffer( samples: [Float], sampleRate: UInt = 48000, amplitude: Float = 1.0 ) -> AVAudioPCMBuffer? {
      
      if let format   = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: Double(sampleRate), channels: 1, interleaved: true),
         let buffer   = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(samples.count)),
         let chanData = buffer.floatChannelData?[0]
      {
          buffer.frameLength = AVAudioFrameCount(samples.count)
      
          for (i, sample) in samples.enumerated() {
              chanData[i] = amplitude * sample
          }
      
          return buffer
      }
      return nil
  }

  
  
  public func write(samples: [Float], sampleRate: UInt = 48000, amplitude: Float = 1.0, to path: URL) {
      guard let buffer = buffer(samples: samples, sampleRate: sampleRate, amplitude: amplitude)
      else {
        log.debug("WavAudio: couldn't create buffer")
        return
      }
      write (
          buffer: buffer,
          to    : path
      )
  }
  
  
  public func write( buffer: AVAudioPCMBuffer, to path: URL)  {
    
    do {
      let file = try AVAudioFile (
        forWriting  : path,
        settings    : buffer.format.settings,
        commonFormat: buffer.format.commonFormat,
        interleaved : buffer.format.isInterleaved
      )
      try file.write(from: buffer)
    }
    catch {
      log.debug("WavAudio: couldn't write file : \(error.localizedDescription)")
    }
      
  }
  
}
