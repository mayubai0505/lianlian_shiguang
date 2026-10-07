import WidgetKit
import SwiftUI

@main
struct LianLianWidgetBundle: WidgetBundle {
    var body: some Widget {
        LianLianWidgetSmall()
        LianLianWidgetMedium()
        LianLianWidgetLarge()
    }
}
