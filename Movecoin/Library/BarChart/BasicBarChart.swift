//
//  BasicBarChart.swift
//  BarChart
//
//  Created by Nguyen Vu Nhat Minh on 19/8/17.
//  Copyright © 2017 Nguyen Vu Nhat Minh. All rights reserved.
//

import UIKit

enum BasicBarChartTime {
    case Today
    case Week
    case Month
}


class BasicBarChart: UIView {
    /// contain all layers of the chart
    private let mainLayer: CALayer = CALayer()
    
    /// contain mainLayer to support scrolling
    private let scrollView: UIScrollView = UIScrollView()
    
    /// A flag to indicate whether or not to animate the bar chart when its data entries changed
    private var animated = false
    
    /// Responsible for compute all positions and frames of all elements represent on the bar chart
    private let presenter = BasicBarChartPresenter(barWidth: 8, space: 5)// 20)
    
    /// An array of bar entries. Each BasicBarEntry contain information about line segments, curved line segments, positions and frames of all elements on a bar.
    private var barEntries: [BasicBarEntry] = [] {
        didSet {
            mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
            
            scrollView.contentSize = CGSize(width: self.frame.size.width, height: self.frame.size.height) // CGSize(width: presenter.computeContentWidth(), height: self.frame.size.height)
            mainLayer.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
            
            showHorizontalLines()
            
            for (index, entry) in barEntries.enumerated() {
                showEntry(index: index, entry: entry, animated: animated, oldEntry: oldValue.safeValue(at: index))
            }
        }
    }
    
    func updateDataEntries(dataEntries: [DataEntry], animated: Bool, time: BasicBarChartTime = .Today) {
        self.animated = animated
        self.presenter.dataEntries = dataEntries
        self.layoutIfNeeded()
        if dataEntries.count != 0 {
            
            self.presenter.space = (self.frame.width - CGFloat((dataEntries.count * 8)))/(CGFloat(dataEntries.count)) // time == .Month ? CGFloat(5) : (self.frame.width - CGFloat((dataEntries.count * 8)))/(CGFloat(dataEntries.count)) // CGFloat(40)
        }
        
        if time == .Today {
            self.presenter.space = 0 // self.frame.width
        }
               
        self.barEntries = self.presenter.computeBarEntries(viewHeight: self.frame.height)
//        self.barEntries = self.presenter.computeBarEntries(viewHeight: self.frame.height, spaceChecked: CGFloat(self.frame.width)/CGFloat(dataEntries.count * 5))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
        scrollView.layer.addSublayer(mainLayer)
        self.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateDataEntries(dataEntries: presenter.dataEntries, animated: false, time: .Today)
    }
    
    private func showEntry(index: Int, entry: BasicBarEntry, animated: Bool, oldEntry: BasicBarEntry?) {
        
        let cgColor = entry.data.color.cgColor
        
        // Show the main bar
        mainLayer.addRectangleLayer(frame: entry.barFrame, color: cgColor, animated: animated, oldFrame: oldEntry?.barFrame)
        
//        mainLayer.addCurvedLayer(curvedSegment: entry, color: cgColor, animated: animated, oldSegment: oldSegment)
//        mainLayer.addCurvedLayer(curvedSegment: CurvedSegment(), color: <#T##CGColor#>, animated: <#T##Bool#>, oldSegment: <#T##CurvedSegment?#>)

        // Show an Int value above the bar
        mainLayer.addTextLayer(frame: entry.textValueFrame, color: cgColor, fontSize: 10, text: entry.data.textValue, animated: animated, oldFrame: oldEntry?.textValueFrame)

        // Show a title below the bar
        mainLayer.addTextLayer(frame: entry.bottomTitleFrame, color: cgColor, fontSize: 10, text: entry.data.title, animated: animated, oldFrame: oldEntry?.bottomTitleFrame)
        
    }
    
    private func showHorizontalLines() {
        self.layer.sublayers?.forEach({
            if $0 is CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        })
        let lines = presenter.computeHorizontalLines(viewHeight: self.frame.height)
        lines.forEach { (line) in
            mainLayer.addLineLayer(lineSegment: line.segment, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor, width: line.width, isDashed: line.isDashed, animated: false, oldSegment: nil)
        }
    }
}
