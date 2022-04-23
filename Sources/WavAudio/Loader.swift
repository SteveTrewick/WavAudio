import Foundation
import AVFoundation
import OSLog


public class Loader {

  let log = Logger()
  
  
  // load samples from a wav file
  // errors are suppressed and logged
  
  public func samples(from path: URL ) -> [Float]  {
      
      let sourceFile: AVAudioFile
      let format    : AVAudioFormat
      
      
      do {
          sourceFile = try AVAudioFile(forReading: path)
          format     = sourceFile.processingFormat
          
      } catch {
          log.debug("WavAudio: unable to load the source audio file: \(error.localizedDescription)")
          return []
      }
      
    
      guard let buffer = AVAudioPCMBuffer (
        pcmFormat    : format,
        frameCapacity: AVAudioFrameCount(sourceFile.length)
      )
      else {
        log.debug("WavAudio: couldn't create PCM buffer")
        return []
      }
    
      
      buffer.frameLength = AVAudioFrameCount(sourceFile.length)
      
      do {
        try sourceFile.read(into: buffer)
      }
      catch {
        log.debug("WavAudio: couldn't read file : \(error.localizedDescription)")
        return []
      }

      
      return Array (
          UnsafeBufferPointer (
            start: buffer.floatChannelData![0],
            count: Int(sourceFile.length)
          )
      )

      
  }
  
  
}
