//
//  TaskCell.swift
//  TodoList
//
//  Created by Jakkula Rakesh on 15/06/24.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var taskStatusView: UIView!
    @IBOutlet weak var taskStatusLbl: UILabel!
    @IBOutlet weak var todoTextLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 4
        taskStatusView.addRightBorderCurve(cornerRadius: 10)
        doneTaskSetupView()
    }

    func inCompleteTaskSetupView() {
        bgView.backgroundColor = .systemRed.withAlphaComponent(0.4)
        taskStatusView.backgroundColor = .systemRed.withAlphaComponent(1)
        taskStatusLbl.text = "Incomplete"
    }
    
    func doneTaskSetupView() {
        bgView.backgroundColor = .systemGreen.withAlphaComponent(0.4)
        taskStatusView.backgroundColor = .systemGreen.withAlphaComponent(1)
        taskStatusLbl.text = "Done"
    }
    
}
