//
//  TestVoiceRecorderView.swift
//  voiceMemo
//
//  Created by 이정동 on 12/7/23.
//

import SwiftUI

struct TestVoiceRecorderView: View {
    @StateObject private var voiceRecorderViewModel = VoiceRecorderViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                CustomNavigationBar(isDisplayLeftButton: false, isDisplayRightButton: false)
                
                // 타이틀 뷰
                TitleView()
                    .padding(.leading, 20)
                
                // 안내 뷰 or 음성메모 리스트 뷰
                if voiceRecorderViewModel.recordedFiles.isEmpty {
                    VoiceRecorderAnnouncementView()
                } else {
                    VoiceRecorderListView(voiceRecorderViewModel: voiceRecorderViewModel)
                }
            }
            
            // 음성메모 버튼 뷰
            VoiceRecordButtonView(voiceRecorderViewModel: voiceRecorderViewModel)
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert(
            "삭제하시겠습니까?",
            isPresented: $voiceRecorderViewModel.isDisplayRemoveVoiceRecorderAlert,
            actions: {
                Button("삭제", role: .destructive) {
                    voiceRecorderViewModel.removeSelectedVoiceRecord()
                }
                Button("취소", role: .cancel) { }
            }
        )
        .alert(
            "\(voiceRecorderViewModel.alertMessage)",
            isPresented: $voiceRecorderViewModel.isDisplayAlert,
            actions: {
                Button("확인", role: .cancel) { }
            }
        )
        
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    
    fileprivate var body: some View {
        HStack {
            Text("음성메모")
                .font(.system(size: 30, weight: .bold))
            Spacer()
        }
    }
}

// MARK: - 음성메모 안내 뷰
private struct VoiceRecorderAnnouncementView: View {
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            Image("pencil")
                .renderingMode(.template)
            Text("현재 등록된 음성메모가 없습니다.")
            Text("하단의 녹음버튼을 눌러 음성메모를 시작해주세요.")
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

// MARK: - 음성메모 리스트 셀 뷰
private struct VoiceRecorderListCellView: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    private var recordedFile: URL
    private var creationDate: Date?
    private var duration: TimeInterval?
    private var progress: Float {
        if voiceRecorderViewModel.selectedRecoredFile == recordedFile &&
            (voiceRecorderViewModel.isPlaying || voiceRecorderViewModel.isPaused) {
            return Float(voiceRecorderViewModel.playedTime) / Float(duration ?? 1)
        } else {
            return 0
        }
    }
    
    fileprivate init(voiceRecorderViewModel: VoiceRecorderViewModel, recordedFile: URL) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
        self.recordedFile = recordedFile
        (creationDate, duration) = voiceRecorderViewModel.getFileInfo(for: recordedFile)
    }
    
    fileprivate var body: some View {
        Button(
            action: {
                voiceRecorderViewModel.voiceRecordCellTapped(recordedFile)
            },
            label: {
                VStack(spacing: 5) {
                    // 음성메모 제목
                    HStack {
                        Text("\(recordedFile.lastPathComponent)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.customBlack)
                        Spacer()
                    }
                    
                    // 생성 날짜 및 녹음 길이
                    HStack {
                        if let creationDate = creationDate {
                            Text("\(creationDate.formattedVoiceRecorderTime)")
                        }
                        Spacer()
                        if voiceRecorderViewModel.selectedRecoredFile != recordedFile,
                           let duration = duration {
                            Text("\(duration.formattedTimeInterval)")
                        }
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.customGray2)
                    
                    // 선택한 음성메모 화면
                    if voiceRecorderViewModel.selectedRecoredFile == recordedFile {
                        // 프로그래스 바
                        ProgressBar(progress: progress)
                            .frame(height: 2)
                        
                        // 재생 시간 및 녹음 길이
                        HStack {
                            Text("\(voiceRecorderViewModel.playedTime.formattedTimeInterval)")
                            Spacer()
                            if let duration = duration {
                                Text("\(duration.formattedTimeInterval)")
                            }
                        }
                        .font(.system(size: 14))
                        .foregroundStyle(Color.customGray2)
                        
                        ZStack {
                            HStack(spacing: 20) {
                                Spacer()
                                
                                // 재생 버튼
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
                                    })
                                
                                // 정지 버튼
                                Button(
                                    action: {
                                        if voiceRecorderViewModel.isPlaying {
                                            voiceRecorderViewModel.pausePlaying()
                                        }
                                    },
                                    label: {
                                        Image("pause")
                                    })
                                Spacer()
                            }
                            
                            HStack {
                                Spacer()
                                Button(
                                    action: {
                                        voiceRecorderViewModel.removeButtonTapped()
                                    },
                                    label: {
                                        Image("trash")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                    })
                            }
                            .padding(.trailing, 20)
                        }
                    }
                }
                .padding(.horizontal, 20)
            })
        Divider()
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
                    .frame(width: CGFloat(progress) * geometry.size.width)
            }
        }
    }
}

// MARK: - 음성메모 버튼 뷰
private struct VoiceRecordButtonView: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    
    fileprivate init(voiceRecorderViewModel: VoiceRecorderViewModel) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
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
                        voiceRecorderViewModel.isRecording
                        ? Image("mic_recording") : Image("mic")
                    })
            }
        }
    }
}

#Preview {
    TestVoiceRecorderView()
}
