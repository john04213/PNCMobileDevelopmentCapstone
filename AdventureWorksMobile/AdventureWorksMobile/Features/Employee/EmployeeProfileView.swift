//
//  EmployeeProfileView.swift
//  AdventureWorksMobile
//
//  Created by Harris Riley on 11/9/26.
//

import SwiftUI

// The profile for one employee. The list row already has the department, shift, and hire date,
// so we keep that employee and load the rest (employee number and shift history) from the API.
struct EmployeeProfileView: View {

    let employee: EmployeeElement
    @State private var viewModel: ViewModel

    init(employee: EmployeeElement, repository: any EmployeeRepositoryProtocol) {
        self.employee = employee
        viewModel = ViewModel(employeeId: employee.employeeId, repository: repository)
    }

    var body: some View {
        VStack {

            LoadingBannerView(
                state: viewModel.state,
                isLoading: viewModel.isLoading,
                refreshErrorMessage: viewModel.refreshErrorMessage,
                itemName: "profile"
            )

            switch viewModel.state {
            case .loading, .idle:
                LoadingView(message: "Loading profile...")
            case .empty:
                EmptyStateView(message: "No profile found")
            case .failed(let errorMessage):
                ErrorStateView(message: errorMessage, retryAction: {
                    Task {
                        await viewModel.loadProfile()
                    }
                })
            case .loaded:
                if let profile = viewModel.profile {
                    List {
                        Section(header: Text("Employee")) {
                            Text("Name: \(profile.fullName)")
                            Text("Job title: \(profile.jobTitle)")
                            Text("Employee number: \(profile.employeeNumber)")
                            Text("Employee ID: \(profile.employeeId)")
                        }
                        Section(header: Text("Department and shift")) {
                            Text("Department: \(employee.department)")
                            Text("Shift: \(employee.shift)")
                            Text("Hired: \(employee.hireDateText)")
                        }
                        Section(header: Text("Shift history")) {
                            ForEach(profile.shiftHistory) { entry in
                                VStack(alignment: .leading) {
                                    Text(entry.departmentName)
                                        .bold()
                                    Text(entry.departmentGroup)
                                        .foregroundStyle(.secondary)
                                    Text("\(entry.shiftName) shift · \(entry.startDateText) to \(entry.endDateText)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .accessibilityElement(children: .combine)
                            }
                        }
                    }
                    .refreshable {
                        await viewModel.loadProfile()
                    }
                }
            }
        }
        .navigationTitle(employee.fullName)
        .task {
            await viewModel.loadProfile()
        }
    }
}

extension EmployeeProfileView {

    @Observable
    class ViewModel {

        let employeeId: Int
        let repository: any EmployeeRepositoryProtocol

        init(employeeId: Int, repository: any EmployeeRepositoryProtocol) {
            self.employeeId = employeeId
            self.repository = repository
        }

        var state = LoadState.idle
        var refreshErrorMessage = ""
        private(set) var isLoading = false

        var profile: EmployeeProfile?

        func loadProfile() async {
            guard !isLoading else { return }
            isLoading = true
            defer { isLoading = false }
            refreshErrorMessage = ""
            if profile == nil { state = LoadState.loading }
            do {
                profile = try await repository.profile(id: employeeId)
                state = LoadState.loaded
            } catch {
                let message = UserFacingMessage.from(error)
                if profile == nil {
                    state = LoadState.failed(message: message)
                } else {
                    refreshErrorMessage = message
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EmployeeProfileView(employee: EmployeeElement(employeeId: 275,
                                                      firstName: "Michael",
                                                      lastName: "Blythe",
                                                      title: nil,
                                                      shift: "Day",
                                                      department: "Sales",
                                                      hireDate: "2011-05-31T00:00:00",
                                                      jobTitle: "Sales Representative"),
                            repository: MockEmployeeRepository())
    }
}
