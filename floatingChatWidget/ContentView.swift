//
//  ContentView.swift
//  floatingChatWidget
//
//  Created by Aadish Jain on 21/05/25.
//

import SwiftUI

struct MessageItem: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct ContentView: View {
    @State private var showChat = false
    @State private var newMessageText = ""
    @State private var messages: [MessageItem] = [
        MessageItem(text: "Hi there! How can I help you today?", isUser: false)
    ]

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            if showChat {
                VStack(spacing: 0) {
                    // Chat Header
                    HStack {
                        Text("Chat Support")
                            .font(.caption)
                            .padding(.leading)

                        Spacer()

                        Button {
                            withAnimation {
                                showChat = false
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.red.opacity(0.6))
                        }
                        .padding(.trailing)
                    }
                    .padding(.vertical, 12)
                    .background(.thinMaterial)

                    Divider()

                    // Messages
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 10) {
                                ForEach(messages) { msg in
                                    MessageBubbleView(messageItem: msg)
                                }
                            }
                            .padding()
                        }
                        .onChange(of: messages.count) { oldCount, newCount in
                            if newCount > oldCount, let lastID = messages.last?.id {
                                withAnimation(.easeInOut) {
                                    proxy.scrollTo(lastID, anchor: .bottom)
                                }
                            }
                        }
                    }

                    // Input
                    chatInputView
                }
                .background(Color(.systemBackground))
                .cornerRadius(25)
                .padding()
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: showChat)
            }

            // Floating Chat Button
            if !showChat {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                showChat = true
                            }
                        } label: {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                                .font(.system(size: 22))
                                .foregroundColor(Color(.systemBackground))
                                .padding()
                                .background(Color.primary)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                        .padding()
                    }
                }
            }
        }
    }

    var chatInputView: some View {
        HStack(spacing: 10) {
            TextField("Type a message...", text: $newMessageText, axis: .vertical)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(.secondarySystemBackground))
                .clipShape(Capsule())
                .lineLimit(1...4)

            Button {
                sendMessage()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 34))
                    .foregroundColor(newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .primary)
            }
            .disabled(newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 14)
    }

    func sendMessage() {
        let trimmed = newMessageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        messages.append(MessageItem(text: trimmed, isUser: true))
        newMessageText = ""
    }
}

struct MessageBubbleView: View {
    let messageItem: MessageItem
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
            if messageItem.isUser { Spacer() }

            Text(messageItem.text)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    messageItem.isUser
                    ? Color.primary.opacity(0.1)
                    : Color.secondary.opacity(0.1)
                )
                .foregroundColor(.primary)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: messageItem.isUser ? .trailing : .leading)

            if !messageItem.isUser { Spacer() }
        }
        .id(messageItem.id)
    }
}

#Preview {
    ContentView()
}
