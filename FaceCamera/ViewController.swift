//
//  ViewController.swift
//  FaceCamera
//
//  Created by Spyc on H26/12/13.
//  Copyright (c) 平成26年 Spyc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    /** 画像取得用 */
    var picker:UIImagePickerController?
    /** 画像認識 */
    var detector:CIDetector?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        picker = UIImagePickerController()
        picker!.delegate = self
        picker!.allowsEditing = false
        //messageTextView.resignFirstResponder()
    }

    @IBAction func onTapAlbumButton(sender: AnyObject) {
        //ライブラリが使用できるかどうか判定
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary))
        {
            self.presentViewController(picker!, animated: true, completion: nil)
        }
    }
    
    /**
    * 写真選択
    */
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: nil)
        //画像を変換
        var ciImage:CIImage = CIImage(image: image)
        // グラフィックスコンテキスト生成
        UIGraphicsBeginImageContextWithOptions(image.size, true, 0);
        // 読み込んだ写真を書き出す
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        // 取得するパラメーターを指定する
        let options = [CIDetectorSmile : true, CIDetectorEyeBlink : true]
        // 画像内に顔があるか調べる
        let features = detector?.featuresInImage(ciImage, options: options)
        for feature in features as [CIFaceFeature] {
            // マスク画像
            let uiImage = UIImage(named:"scope")
            var faceRect = feature.bounds
            // 位置の補正
            faceRect.origin.y = image.size.height - faceRect.origin.y - faceRect.size.height
            // 顔の場所に書き出す
            uiImage?.drawInRect(faceRect)
        }
        // グラフィックスコンテキストの画像を取得
        var outputImage = UIGraphicsGetImageFromCurrentImageContext()
        // グラフィックスコンテキストの編集を終了
        UIGraphicsEndImageContext();
        // 画像を出力
        photoImageView.image = outputImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

