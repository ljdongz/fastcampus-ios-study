//
//  VoiceRecorderView.swift
//  voiceMemo
//

import SwiftUI

struct VoiceRecorderView: View {
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @StateObject private var voiceRecorderViewModel = VoiceRecorderViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                CustomNavigationBar(
                    isDisplayLeftButton: false,
                    isDisplayRightButton: false
                )
                
                // 타이틀 뷰
                TitleView()
                
                // 안내 뷰 or 리스트 뷰
                if voiceRecorderViewModel.recordedFiles.isEmpty {
                    VoiceRecorderAnnouncementView()
                } else {
                    VoiceRecorderListView(voiceRecorderViewModel: voiceRecorderViewModel)
                        .padding(.top, 15)
                }
            }
            
            // 녹음 버튼 뷰
            VoiceRecorderButtonView(voiceRecorderViewModel: voiceRecorderViewModel)
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert(
            "선택된 음성메모를 삭제하시겠습니까?",
            isPresented: $voiceRecorderViewModel.isDisplayRemoveVoiceRecorderAlert
        ) {
            Button("삭제", role: .destructive) {
                voiceRecorderViewModel.removeSelectedVoiceRecord()
            }
            Button("취소", role: .cancel) { }
        }
        .alert(
            voiceRecorderViewModel.alertMessage,
            isPresented: $voiceRecorderViewModel.isDisplayAlert
        ) {
            Button("확인", role: .cancel) { }
        }
        .onAppear(perform: {
            voiceRecorderViewModel.requestAudioPermission()
        })
        .onChange(of: voiceRecorderViewModel.recordedFiles) { files in
            homeViewModel.setVoiceRecordersCount(files.count)
        }
        
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    
    fileprivate var body: some View {
        HStack {
            Text("음성메모")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.customBlack)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 30)
    }
}

// MARK: - 음성메모 안내 뷰
private struct VoiceRecorderAnnouncementView: View {
    
    fileprivate var body: some View {
        VStack(spacing: 5) {
            Spacer()
            Image("pencil")
                .renderingMode(.template)
            Text("현재 등록된 음성메모가 없습니다.")
            Text("하단의 녹음 버튼을 눌러 음성메모를 시작해주세요.")
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundStyle(Color.customGray2)
    }
}

// MARK: - 음성메모 리스트 뷰
private struct VoiceRecorderListView: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    
    fileprivate init(voiceRecorderViewModel: VoiceRecorderViewModel) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
    }
    
    fileprivate var body: some View {
        ScrollView {
            VStack {
                Divider()
                
                ForEach(voiceRecorderViewModel.recordedFiles, id: \.self) { recordedFile in
                    VoiceRecorderListCellView(
                        voiceRecorderViewModel: voiceRecorderViewModel,
                        recordedFile: recordedFile
                    )
                }
            }
        }
    }
}

// MARK: - 음성메모 리스트 셀 뷰
private struct VoiceRecorderListCellView: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    
    private var recordedFile: URL
    private var creationDate: Date?
    private var duration: TimeInterval?
    
    /*
     progressBarValue는 property wrapper로 선언된 voiceRecorderViewModel의 프로퍼티에
     의존하고 있음. (selectedRecoredFile, isPlaying, isPaused, playedTime)
     따라서, 이들 프로퍼티 중 하나가 변경될 때마다 progressBarValue값이 새로 계산되어 갱신됨.
     */
    private var progressBarValue: Float {
        if voiceRecorderViewModel.selectedRecoredFile == recordedFile
            && (voiceRecorderViewModel.isPlaying || voiceRecorderViewModel.isPaused) {
            return Float(voiceRecorderViewModel.playedTime) / Float(duration ?? 1)
        } else {
            return 0
        }
    }
    
    fileprivate init(
        voiceRecorderViewModel: VoiceRecorderViewModel,
        recordedFile: URL
    ) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
        self.recordedFile = recordedFile
        (self.creationDate, self.duration) = voiceRecorderViewModel.getFileInfo(for: recordedFile)
    }
    
    fileprivate var body: some View {
        VStack(spacing: 10) {
            Button(
                action: {
                    voiceRecorderViewModel.voiceRecordCellTapped(recordedFile)
                },
                label: {
                    VStack(spacing: 5) {
                        // 음성메모 제목
                        HStack {
                            Text(recordedFile.lastPathComponent)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(Color.customBlack)
                            
                            Spacer()
                        }
                        
                        // 생성 날짜 및 녹음 길이
                        HStack {
                            if let creationDate = creationDate {
                                Text(creationDate.formattedVoiceRecorderTime)
                            }
                            Spacer()
                            if voiceRecorderViewModel.selectedRecoredFile != recordedFile,
                               let duration = duration {
                                Text(duration.formattedTimeInterval)
                            }
                        }
                        .font(.system(size: 14))
                        .foregroundStyle(Color.customIconGray)
                    }
                })
            .padding(.horizontal, 20)
            
            if voiceRecorderViewModel.selectedRecoredFile == recordedFile {
                VStack(spacing: 5) {
                    // 프로그래스바
                    ProgressBar(progress: progressBarValue)
                        .frame(height: 2)
                    
                    HStack {
                        Text(voiceRecorderViewModel.playedTime.formattedTimeInterval)
                        
                        Spacer()
                        
                        if let duration = duration {
                            Text(duration.formattedTimeInterval)
                        }
                    }
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(Color.customIconGray)
                    
                    // 하단 재생, 일시정지, 삭제 버튼
                    HStack(spacing: 10) {
                        Spacer()
                        
                        Button(
                            action: {
                                if voiceRecorderViewModel.isPaused {
                                    voiceRecorderViewModel.resumePlaying()
                                } else {
                                    voiceRecorderViewModel.startPlaying(recordingURL: recordedFile)
                                }
                            },
                            label: {
                                Image("play")
                                    .renderingMode(.template)
                                    .foregroundStyle(Color.customBlack)
                            }
                        )
                        
                        Button(
                            action: {
                                if voiceRecorderViewModel.isPlaying {
                                    voiceRecorderViewModel.pausePlaying()
                                }
                            },
                            label: {
                                Image("pause")
                                    .renderingMode(.template)
                                    .foregroundStyle(Color.customBlack)
                            }
                        )
                        
                        Spacer()
                        
                        Button(
                            action: {
                                voiceRecorderViewModel.removeButtonTapped()
                            },
                            label: {
                                Image("trash")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(Color.customBlack)
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Divider()
        }
    }
}

// MARK: - 프로그래스 바
private struct ProgressBar: View {
    private var progress: Float
    
    fileprivate init(progress: Float) {
        self.progress = progress
    }
    
    fileprivate var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.customGray2)
                
                Rectangle()
                    .fill(Color.customGreen)
                    .frame(width: CGFloat(self.progress) * geometry.size.width)
            }
        }
    }
}

// MARK: - 녹음 버튼
private struct VoiceRecorderButtonView: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    @State private var isAnimation: Bool
    
    fileprivate init(
        voiceRecorderViewModel: VoiceRecorderViewModel,
        isAnimation: Bool = false
    ) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
        self.isAnimation = isAnimation
    }
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                Button(
                    action: {
                        voiceRecorderViewModel.recordButtonTapped()
                    },
                    label: {
                        if voiceRecorderViewModel.isRecording {
                            Image("mic_recording")
                                .scaleEffect(isAnimation ? 1.5 : 1)
                                .onAppear {
                                    withAnimation(
                                        .spring().repeatForever()) {
                                            isAnimation.toggle()
                                        }
                                }
                                .onDisappear {
                                    isAnimation = false
                                }
                        } else {
                            Image("mic")
                        }
                    })
            }
        }
    }
}

struct VoiceRecorderView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceRecorderView()
    }
}
