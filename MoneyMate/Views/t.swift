import SwiftUI

// 数据模型：用户
struct User: Identifiable, Hashable {
    let id: Int
    let name: String
    let age: Int
    let profileDescription: String
}

// 模拟的用户数据
let users = [
    User(
        id: 1, name: "Alice", age: 28,
        profileDescription: "A software developer from New York."),
    User(
        id: 2, name: "Bob", age: 32,
        profileDescription: "A designer from California."),
    User(
        id: 3, name: "Charlie", age: 24,
        profileDescription: "A student from Texas."),
]

// 主页面
struct CContentView: View {
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 40) {
                // 用户列表
                List(users) { user in
                    NavigationLink(value: user) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(user.name)
                                    .font(.headline)
                                Text("\(user.age) 岁")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(.insetGrouped)
                
                // 导航到设置页面
                NavigationLink("设置", value: "Settings")
                    .font(.title2)
                    .padding(.top, 20)
            }
            .navigationTitle("用户列表")
            .navigationDestination(for: User.self) { user in
                UserDetailsView(user: user)
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "Settings" {
                    SettingsView()
                }
            }
        }
    }
}

// 用户详情页面
struct UserDetailsView: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 20) {
            Text("姓名: \(user.name)")
                .font(.largeTitle)
                .bold()
            Text("年龄: \(user.age)")
                .font(.title3)
                .foregroundColor(.secondary)
            Text(user.profileDescription)
                .font(.body)
                .padding()
            
            // 导航到个人资料页面
            NavigationLink("查看个人资料") {
                UserProfileView(user: user)
            }
            .padding(.top, 20)
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("用户详情")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

// 用户个人资料页面
struct UserProfileView: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 20) {
            Text("\(user.name) 的个人资料")
                .font(.largeTitle)
                .bold()
            Text("年龄: \(user.age)")
                .font(.title3)
                .foregroundColor(.secondary)
            Text(user.profileDescription)
                .font(.body)
                .padding()
        }
        .navigationTitle("个人资料")
        .padding()
    }
}

// 设置页面
struct SettingsView: View {
    @State private var isNotificationsEnabled = true
    @State private var isDarkModeEnabled = false
    
    var body: some View {
        Form {
            Toggle("接收通知", isOn: $isNotificationsEnabled)
            Toggle("启用暗黑模式", isOn: $isDarkModeEnabled)
        }
        .navigationTitle("设置")
    }
}

// 预览
struct CContentView_Previews: PreviewProvider {
    static var previews: some View {
        CContentView()
    }
}
