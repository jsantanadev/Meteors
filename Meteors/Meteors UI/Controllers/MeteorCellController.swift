import UIKit

public class MeteorCellController: NSObject, UITableViewDataSource {
    private let viewModel: MeteorViewModel
    
    public init(viewModel: MeteorViewModel) {
        self.viewModel = viewModel
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MeteorCell = tableView.dequeueReusableCell(for: indexPath)
        cell.nameLabel.text = viewModel.name
        cell.infoLabel.text = viewModel.info
        return cell
    }
}
