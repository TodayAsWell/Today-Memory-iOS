//
//  FilterView.swift
//  TodayCamera
//
//  Created by 박준하 on 2023/05/19.
//
//
//import AVFoundation
import CoreImage
import CoreMedia
import UIKit
import AVFoundation

class FilterView: UIView {
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureSession: AVCaptureSession?
    
    override init(frame: CGRect) {
        super.init(frame: frame
                   
        setupCaptureSession()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCaptureSession()
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("Unable to access camera")
            return
        }
        
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              captureSession!.canAddInput(videoInput) else {
            print("Unable to add video input")
            return
        }
        
        captureSession!.addInput(videoInput)
        videoPreviewLayer = layer as? AVCaptureVideoPreviewLayer
        videoPreviewLayer?.session = captureSession
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        
        captureSession!.startRunning()
    }
}

extension FilterView {
    func applyFilter() {
        guard let captureSession = captureSession,
              let videoOutput = captureSession.outputs.first as? AVCaptureVideoDataOutput,
              let connection = videoOutput.connection(with: .video) else {
            return
        }
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", attributes: []))
        
        let videoFilter = CIFilter(name: "CISepiaTone")
        
        connection.videoOrientation = .portrait
        
        videoOutput.alwaysDiscardsLateVideoFrames = true
        
        captureSession.startRunning()
    }
}

extension FilterView: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer)
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(cameraImage, forKey: kCIInputImageKey)
        filter?.setValue(0.8, forKey: kCIInputIntensityKey)
        
        if let filteredImage = filter?.outputImage {
            let context = CIContext()
            let cgImage = context.createCGImage(filteredImage, from: filteredImage.extent)
            
            DispatchQueue.main.async { [weak self] in
                self?.layer.contents = cgImage
            }
        }
    }
}
