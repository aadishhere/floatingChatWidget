//
//  ContentView.swift
//  floatingChatWidget
//
//  Created by Aadish Jain on 21/05/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showChat = false
    @State private var message = ""
    @State private var messages: [String] = ["Hi there! How can I help you?"]
    
    var body: some View {
        ZStack {
            //Background
            Color(.systemBackground)
                .ignoresSafeArea()
            
            //Chat Box
            if showChat {
                
                VStack {
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        
                        HStack {
                            
                            Text("Chat Support")
                                .font(.caption)
                            
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    showChat = false
                                }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.red.opacity(0.6))
                            }
                            
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        
                        Divider()
                        
                        ScrollView {
                            
                            VStack(alignment: .leading, spacing: 10) {
                                
                                ForEach(messages, id: \.self) { msg in
                                    Text(msg)
                                        .padding()
                                        .background(Color.primary.opacity(0.1))
                                        .cornerRadius(50)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            
                            .padding()
                        }
                        
                        .frame(height: 400)
                        .cornerRadius(50)
                        
                        HStack {
                            
                            TextField("type a message...", text: $message)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(25)
                                    
                            Button {
                                if !message.isEmpty {
                                    messages.append(message)
                                    message = ""
                                }
                            } label: {
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 35))
                                    .foregroundColor(.primary.opacity(0.6))
                            }
                        }
                        .padding()
                    }
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(35)
                    .shadow(color: Color.primary.opacity(0.2), radius: 3)
                    .padding()
                    .transition(.move(edge: .bottom))
                }
                .animation(.easeInOut, value: showChat)
                .ignoresSafeArea()
            }
            
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
                                .font(.system(size: 20))
                                .foregroundColor(Color(UIColor.systemBackground))
                                .padding()
                                .background(Color.primary.opacity(0.6))
                                .clipShape(Circle())
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
