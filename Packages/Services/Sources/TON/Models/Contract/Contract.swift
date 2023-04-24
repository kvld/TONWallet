//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import Foundation
import BOC

protocol Contract {
    var code: Cell { get throws }
    var data: Cell { get throws }
}
