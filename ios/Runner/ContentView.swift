import FamilyControls
import SwiftUI

struct ContentView: View {
    // 不再使用的状态变量，保留以避免影响现有代码
    @State private var isDiscouragedPresented = true
    @State private var isEncouragedPresented = false

    // 环境对象
    @EnvironmentObject var model: MyModel
    @Environment(\.presentationMode) var presentationMode

    // 应用选择器视图
    @ViewBuilder
    func contentView() -> some View {
        VStack(spacing: 20) {
            // 应用选择器
            FamilyActivityPicker(selection: $model.selectionToDiscourage)
                // 只存储选择，不自动应用限制
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                contentView()
                
                // 添加底部的帮助提示
                Spacer()
                Text("选择完成后点击右上角的完成按钮")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)
            }
            .navigationBarTitle("选择白名单应用", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("取消")
                        .foregroundColor(.blue)
                },
                trailing: Button(action: {
                    // 只存储选择，不应用限制，然后关闭界面
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("完成")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MyModel())
    }
}
