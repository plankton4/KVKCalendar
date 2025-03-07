//
//  Style.swift
//  KVKCalendar
//
//  Created by Sergei Kviatkovskii on 02/01/2019.
//

#if os(iOS)

import UIKit

private let gainsboro: UIColor = UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1)

public struct Style {
    public var event = EventStyle()
    public var timeline = TimelineStyle()
    public var week = WeekStyle()
    public var allDay = AllDayStyle()
    public var headerScroll = HeaderScrollStyle()
    public var month = MonthStyle()
    public var year = YearStyle()
    public var list = ListViewStyle()
    public var locale = Locale.current
    public var calendar = Calendar.current
    public var timezone = TimeZone.current
    public var defaultType: CalendarType?
    public var timeSystem: TimeHourSystem = .twentyFour
    /// Only valid in 24-hour format
    public var isEndOfDayZero: Bool = true
    public var startWeekDay: StartDayType = .monday
    public var followInSystemTheme: Bool = true
    public var systemCalendars: Set<String> = []
    /// Linux timezone identifiers
    public var timeZoneIds: [String] = ["America/New_York", "Europe/London", "Europe/Moscow", "Asia/Tokyo"]
    public var selectedTimeZones: [TimeZone]
    
    public init(configureAsDefaultCalendar: Bool = true) {
        selectedTimeZones = [timezone]
        
        guard configureAsDefaultCalendar else { return }
        
        if Platform.currentInterface == .phone {
            timeline.offsetTimeX = 2
            timeline.offsetLineLeft = 2
            timeline.offsetLineRight = 0
            headerScroll.titleDateAlignment = .center
            headerScroll.isAnimateTitleDate = true
            headerScroll.heightHeaderWeek = 70
            event.isEnableVisualSelect = false
            month.isHiddenEventTitle = true
            month.weekDayAlignment = .center
            month.isHiddenSeparatorOnEmptyDate = true
            month.colorBackgroundWeekendDate = .clear
            month.fontTitleHeader = .boldSystemFont(ofSize: 19)
            month.isHiddenSectionHeader = false
            month.isHiddenTitleHeader = true
            week.colorBackground = .white
        } else {
            timeline.widthEventViewer = 350
            headerScroll.fontNameDay = .systemFont(ofSize: 17)
        }
        
        timeline.isHiddenTimeIfCurrentCrossed = false
        timeSystem = .current ?? .twelve
    }
}

// MARK: Header scroll style

public struct HeaderScrollStyle {
    public var titleDays: [String] = []
    public var heightHeaderWeek: CGFloat = 50
    
    public var heightSubviewHeader: CGFloat = 30 {
        didSet {
            if heightSubviewHeader > 0 {
                heightSubviewHeaderCached = heightSubviewHeader
            }
        }
    }
    private var heightSubviewHeaderCached: CGFloat = 30
    public var colorBackground: UIColor = gainsboro.withAlphaComponent(0.4)
    public var isHiddenSubview: Bool = false {
        didSet {
            if isHiddenSubview {
                heightSubviewHeader = 0
            } else {
                heightSubviewHeader = heightSubviewHeaderCached
            }
        }
    }
    
    public var titleFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateStyle = .full
        return format
    }()
    public var weekdayFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "EE"
        return format
    }()
    
    public var titleDateColor: UIColor = .black
    public var titleDateColorCorner: UIColor = .red
    public var colorDate: UIColor = .black
    public var fontDate: UIFont = .systemFont(ofSize: 17)
    public var colorNameDay: UIColor = .black
    public var fontNameDay: UIFont = .systemFont(ofSize: 10)
    public var colorCurrentDate: UIColor = .white
    public var colorBackgroundCurrentDate: UIColor = .red
    public var colorBackgroundSelectDate: UIColor = .black
    public var colorSelectDate: UIColor = .white
    public var colorCurrentSelectDateForDarkStyle: UIColor = .white
    public var colorWeekendDate: UIColor = .gray
    public var isScrollEnabled: Bool = true
    public var colorWeekdayBackground: UIColor = .clear
    public var colorWeekendBackground: UIColor = .clear
    public var isHidden: Bool = false
    public var dotCorners: UIRectCorner = .allCorners
    public var dotCornersRadius: CGSize?
    public var titleDateAlignment: NSTextAlignment = .left
    public var titleDateFont: UIFont = .boldSystemFont(ofSize: 20)
    public var isAnimateTitleDate: Bool = false
    public var colorNameEmptyDay: UIColor = gainsboro
    public var showDatesForOtherMonths: Bool = true
    public var isAnimateSelection: Bool = true
    public var shouldTimelineTrackScroll: Bool = true
    public var bottomLineColor: UIColor = gainsboro
    
    var backgroundBlurStyle: UIBlurEffect.Style? = nil
}

// MARK: Timeline style

public protocol CurrentLineStyleDisplayable {
    var lineHourStyle: TimelineStyle.CurrentLineHourStyle { get set }
    var timeFont: UIFont { get set }
    var lineColor: UIColor { get set }
    var timeColor: UIColor { get set }
    var timeDotSize: CGSize { get set }
    var dotCornersRadius: CGSize { get set }
    var timeCornersRadius: CGSize { get set }
    var timeWidth: CGFloat { get set }
    var lineHeight: CGFloat { get set }
    var dateFormatter: DateFormatter? { get set }
}

public struct TimelineStyle {
    public var startFromFirstEvent: Bool = false
    public var eventFont: UIFont = .boldSystemFont(ofSize: 12)
    public var offsetEvent: CGFloat = 3
    public var startHour: Int = 0
    public var endHour: Int = 24
    public var scrollToHour: Int? = nil
    public var movingMinuteLabelRoundUpTime: UInt = 15
    var minuteLabelRoundUpTime: Int {
        guard 1...60 ~= movingMinuteLabelRoundUpTime else { return 1 }
        
        return Int(movingMinuteLabelRoundUpTime)
    }
    public var heightLine: CGFloat = {
#if targetEnvironment(macCatalyst)
        return 1
#else
        return 0.5
#endif
    }()
    public var widthLine: CGFloat = {
#if targetEnvironment(macCatalyst)
        return 1
#else
        return 0.5
#endif
    }()
    public var offsetTop: CGFloat = 0
    public var offsetLineLeft: CGFloat = 10
    public var offsetLineRight: CGFloat = 10
    public var backgroundColor: UIColor = .white
    public var widthTime: CGFloat = 40
    public var heightTime: CGFloat = 20
    public var offsetTimeX: CGFloat = 10
    public var offsetTimeY: CGFloat = 25
    public var timeColor: UIColor = .systemGray
    public var timeSuffixColor: UIColor = .systemGray3
    public var timeAlignment: NSTextAlignment = .center
    public var timeFont: UIFont = .systemFont(ofSize: 13, weight: .medium)
    public var timeSuffixFont: UIFont = .systemFont(ofSize: 9, weight: .light)
    public var isHiddenTimeIfCurrentCrossed: Bool = true
    public var widthEventViewer: CGFloat? = nil
    public var showLineHourMode: CurrentLineHourShowMode = .today
    public var scrollLineHourMode: CurrentLineHourScrollMode = .today
    
    @available(swift, deprecated: 0.6.28, message: "Use `currentLineHourStyle` instead.", renamed: "currentLineHourStyle")
    public var lineHourStyle: CurrentLineHourStyle = .withTime
    
    @available(swift, deprecated: 0.6.28, message: "Use `currentLineHourStyle` instead.", renamed: "currentLineHourStyle")
    public var currentLineHourFont: UIFont = .systemFont(ofSize: 12)
    
    @available(swift, deprecated: 0.6.28, message: "Use `currentLineHourStyle` instead.", renamed: "currentLineHourStyle")
    public var currentLineHourColor: UIColor = .red
    
    @available(swift, deprecated: 0.6.28, message: "Use `currentLineHourStyle` instead.", renamed: "currentLineHourStyle")
    public var currentLineHourDotSize: CGSize = CGSize(width: 5, height: 5)
    
    @available(swift, deprecated: 0.6.28, message: "Use `currentLineHourStyle` instead.", renamed: "currentLineHourStyle")
    public var currentLineHourDotCornersRadius: CGSize = CGSize(width: 2.5, height: 2.5)
    
    @available(swift, deprecated: 0.6.28, message: "Use `currentLineHourStyle` instead.", renamed: "currentLineHourStyle")
    public var currentLineHourWidth: CGFloat = 40
    
    @available(swift, deprecated: 0.6.28, message: "Use `currentLineHourStyle` instead.", renamed: "currentLineHourStyle")
    public var currentLineHourHeight: CGFloat = 1

    /// to use the previous style set `.old(OldCurrentLineStyle())`
    public var currentLineHourStyle: TimelineStyle.CurrentLineStyleType = .ios18AndHigher(DefaultCurrentLineStyle())
    
    public var separatorLineColor: UIColor = .gray
    public var movingMinutesColor: UIColor = .systemBlue
    public var shadowColumnColor: UIColor = .systemTeal
    public var shadowColumnAlpha: CGFloat = 0.1
    public var minimumPressDuration: TimeInterval = 0.5
    public var isHiddenStubEvent: Bool = true
    public var isEnabledCreateNewEvent: Bool = true
    public var isEnabledForceDeselectEvent: Bool = true
    public var isEnabledDefaultTapGestureRecognizer: Bool = true
    public var createNewEventMethod: CreateNewEventMethod = .longTap
    public var maxLimitCachedPages: UInt = 10
    public var scrollDirections: Set<ScrollDirectionType> = Set(ScrollDirectionType.allCases)
    public var dividerType: DividerType? = nil
    public var eventLayout: TimelineEventLayout = DefaultTimelineEventLayout()
    public var timeDividerColor: UIColor = .lightGray
    public var timeDividerFont: UIFont = .systemFont(ofSize: 10)
    public var scale: Scale? = Scale(min: 1, max: 6)
    public var useDefaultCorderHeader = false
    public var eventPreviewSize: CGSize? = CGSize(width: 150, height: 150)
    
    /// Takes effect when `style.event.states` does not contain `.move`. `true`: create a new event at the long press; `false`: create at the start time.
    @available(swift, deprecated: 0.6.28, message: "The property is not used anymore. Please use `createNewEventMethod` instead.")
    public var createEventAtTouch = false
    
    /// works on the `Day` view
    public var isHiddenTimeVerticalSeparateLine = true

    public var allLeftOffset: CGFloat {
        widthTime + offsetTimeX + offsetLineLeft
    }
    
    public enum ViewMode: Int {
        case `default`, list
    }
    
    public enum CurrentLineStyleType: Equatable {
        case ios18AndHigher(any CurrentLineStyleDisplayable)
        case ios17AndLower(any CurrentLineStyleDisplayable)
        
        var style: any CurrentLineStyleDisplayable {
            switch self {
            case .ios18AndHigher(let item):
                item
            case .ios17AndLower(let item):
                item
            }
        }
        
        var isIos18AndHigher: Bool {
            switch self {
            case .ios18AndHigher:
                true
            case .ios17AndLower:
                false
            }
        }
        
        public static func == (
            lhs: TimelineStyle.CurrentLineStyleType,
            rhs: TimelineStyle.CurrentLineStyleType
        ) -> Bool {
            func compare<E: Equatable>(_ kp: KeyPath<TimelineStyle.CurrentLineStyleType, E>) -> Bool {
                lhs[keyPath: kp] == rhs[keyPath: kp]
            }
            return compare(\.style.lineHourStyle)
            && compare(\.style.timeFont)
            && compare(\.style.lineColor)
            && compare(\.style.timeColor)
            && compare(\.style.dotCornersRadius)
            && compare(\.style.timeDotSize)
            && compare(\.style.timeCornersRadius)
            && compare(\.style.timeWidth)
            && compare(\.style.lineHeight)
            && compare(\.style.dateFormatter)
        }
    }
    
    // default style like in iOS 18
    public struct DefaultCurrentLineStyle: CurrentLineStyleDisplayable {
        public var lineHourStyle: CurrentLineHourStyle
        public var timeFont: UIFont
        public var lineColor: UIColor
        public var timeColor: UIColor
        public var timeDotSize: CGSize
        public var dotCornersRadius: CGSize
        public var timeCornersRadius: CGSize
        public var timeWidth: CGFloat
        public var lineHeight: CGFloat
        public var dateFormatter: DateFormatter?
        
        public init(
            lineHourStyle: CurrentLineHourStyle = .withTime,
            timeFont: UIFont = .systemFont(ofSize: 13, weight: .semibold),
            lineColor: UIColor = .red,
            timeColor: UIColor = .white,
            timeDotSize: CGSize = CGSize(width: 6, height: 6),
            dotCornersRadius: CGSize = CGSize(width: 3, height: 3),
            timeCornersRadius: CGSize = CGSize(width: 5, height: 5),
            timeWidth: CGFloat = 40,
            lineHeight: CGFloat = 2,
            dateFormatter: DateFormatter? = nil
        ) {
            self.lineHourStyle = lineHourStyle
            self.timeFont = timeFont
            self.lineColor = lineColor
            self.timeColor = timeColor
            self.timeDotSize = timeDotSize
            self.dotCornersRadius = dotCornersRadius
            self.timeCornersRadius = timeCornersRadius
            self.timeWidth = timeWidth
            self.lineHeight = lineHeight
            self.dateFormatter = dateFormatter
        }
    }
    
    public struct OldCurrentLineStyle: CurrentLineStyleDisplayable {
        public var lineHourStyle: CurrentLineHourStyle
        public var timeFont: UIFont
        public var lineColor: UIColor
        public var timeColor: UIColor
        public var timeDotSize: CGSize
        public var dotCornersRadius: CGSize
        public var timeCornersRadius: CGSize
        public var timeWidth: CGFloat
        public var lineHeight: CGFloat
        public var dateFormatter: DateFormatter?
        
        public init(
            lineHourStyle: CurrentLineHourStyle = .withTime,
            timeFont: UIFont = .systemFont(ofSize: 12),
            lineColor: UIColor = .red,
            timeColor: UIColor = .white,
            timeDotSize: CGSize = CGSize(width: 5, height: 5),
            dotCornersRadius: CGSize = CGSize(width: 5, height: 5),
            timeCornersRadius: CGSize = CGSize(width: 2.5, height: 2.5),
            timeWidth: CGFloat = 40,
            lineHeight: CGFloat = 1,
            dateFormatter: DateFormatter? = nil
        ) {
            self.lineHourStyle = lineHourStyle
            self.timeFont = timeFont
            self.lineColor = lineColor
            self.timeColor = timeColor
            self.timeDotSize = timeDotSize
            self.dotCornersRadius = dotCornersRadius
            self.timeCornersRadius = timeCornersRadius
            self.timeWidth = timeWidth
            self.lineHeight = lineHeight
            self.dateFormatter = dateFormatter
        }
    }
    
    public struct Scale {
        public var min: CGFloat
        public var max: CGFloat
    }
    
    public enum DividerType: Int {
        case mins5 = 12
        case mins15 = 4
        case mins30 = 2
        
        var minutes: Int {
            switch self {
            case .mins5:
                return 5
            case .mins15:
                return 15
            case .mins30:
                return 30
            }
        }
    }
    
    public enum ScrollDirectionType: Int, CaseIterable {
        case vertical, horizontal
    }
    
    public enum CurrentLineHourStyle: Equatable {
        case withTime
        case onlyLine
    }

    public enum CurrentLineHourShowMode: Equatable {
        case always, today, forDate(Date), never
        
        func showForDates(_ dates: [Date]) -> Bool {
            switch self {
            case .always:
                return true
            case .today:
                let date = Date()
                return dates.contains(where: { date.kvkIsEqual($0) })
            case .forDate(let date):
                return dates.contains(where: { date.kvkIsEqual($0) })
            case .never:
                return false
            }
        }
        
    }
    
    public enum CurrentLineHourScrollMode: Equatable {
        case always, today, forDate(Date), never, onlyOnInitForDate(Date)
        
        func scrollForDates(_ dates: [Date]) -> Bool {
            switch self {
            case .always:
                return true
            case .today:
                let date = Date()
                return dates.contains(where: { date.kvkIsEqual($0) })
            case .forDate(let date), .onlyOnInitForDate(let date):
                return dates.contains(where: { date.kvkIsEqual($0) })
            case .never:
                return false
            }
        }
    }

    public enum CreateNewEventMethod: Equatable {
        case tap, longTap
        
        var isMovable: Bool {
            switch self {
            case .longTap:
                return true
            default:
                return false
            }
        }
        
        var isRegularTap: Bool {
            switch self {
            case .tap:
                return true
            default:
                return false
            }
        }
    }
}

// MARK: Week style

public struct WeekStyle {
    public var colorBackground: UIColor = gainsboro.withAlphaComponent(0.2)
    public var colorDate: UIColor = .black
    public var colorNameDay: UIColor = .black
    public var colorCurrentDate: UIColor = .white
    public var colorBackgroundCurrentDate: UIColor = .systemRed
    public var colorBackgroundSelectDate: UIColor = .black
    public var colorSelectDate: UIColor = .white
    public var colorWeekendDate: UIColor = .gray
    public var colorWeekendBackground: UIColor = .clear
    public var colorWeekdayBackground: UIColor = .clear
    public var selectCalendarType: CalendarType = .day
    public var showVerticalDayDivider: Bool = true
    public var daysInOneWeek: UInt = 7
    public var viewMode: TimelineStyle.ViewMode = .default
    
    var maxDays: Int {
        guard 2...6 ~= daysInOneWeek else { return 7 }
        
        return Int(daysInOneWeek)
    }
}

// MARK: Month style

public struct MonthStyle {
    public var titleFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "MMMM yyyy"
        return format
    }()
    public var weekdayFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "EE"
        return format
    }()
    public var shortInDayMonthFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "MMM"
        return format
    }()
    public var heightHeaderWeek: CGFloat = 25
    public var heightTitleHeader: CGFloat = 40
    public var isHiddenTitleHeader: Bool = false
    public var colorDate: UIColor = .black
    public var colorNameEmptyDay: UIColor = gainsboro
    public var fontNameDate: UIFont = .boldSystemFont(ofSize: 16)
    public var colorCurrentDate: UIColor = .white
    public var colorBackgroundCurrentDate: UIColor = .systemRed
    public var colorBackgroundSelectDate: UIColor = .black
    public var colorSelectDate: UIColor = .white
    public var colorWeekendDate: UIColor = .gray
    public var moreTitle: String = "more"
    public var isHiddenMoreTitle: Bool = false
    public var colorMoreTitle: UIColor = .gray
    public var colorEventTitle: UIColor = .black
    public var weekFont: UIFont = .boldSystemFont(ofSize: 14)
    public var fontEventTitle: UIFont = .systemFont(ofSize: 14)
    public var fontEventTime: UIFont = .systemFont(ofSize: 10)
    public var fontEventBullet: UIFont = .boldSystemFont(ofSize: 18)
    public var isHiddenSeparator: Bool = false
    public var isHiddenSeparatorOnEmptyDate: Bool = false
    public var widthSeparator: CGFloat = 0.3
    public var colorSeparator: UIColor = gainsboro.withAlphaComponent(0.9)
    public var colorBackgroundWeekendDate: UIColor = gainsboro.withAlphaComponent(0.2)
    public var colorBackgroundDate: UIColor = .white
    public var scrollDirection: UICollectionView.ScrollDirection = .vertical
    public var selectCalendarType: CalendarType = .week
    public var isAnimateSelection: Bool = false
    public var isPagingEnabled: Bool = false
    public var isScrollEnabled: Bool = true
    public var autoSelectionDateWhenScrolling: Bool = false
    public var eventCorners: UIRectCorner = .allCorners
    public var eventCornersRadius: CGSize = CGSize(width: 5, height: 5)
    public var isHiddenDotInTitle: Bool = false
    public var isHiddenEventTitle: Bool = false
    public var weekDayAlignment: NSTextAlignment = .right
    public var titleHeaderAlignment: NSTextAlignment = .left
    public var fontTitleHeader: UIFont = .boldSystemFont(ofSize: 30)
    public var colorTitleHeader: UIColor = .black
    public var colorTitleCurrentDate: UIColor = .systemRed
    public var showDatesForOtherMonths: Bool = false
    public var colorBackground: UIColor = .white
    public var selectionMode: SelectionMode = .multiple
    public var showMonthNameInFirstDay: Bool = false
    public var isPrefetchingEnabled: Bool = true
    public var isHiddenSectionHeader: Bool = true
    public var heightSectionHeader: CGFloat = 50
    
    public enum SelectionMode: Int {
        case single, multiple, disabled
    }
}

// MARK: Year style

public struct YearStyle {
    public var titleFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        return format
    }()
    
    public var weekdayFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "EE"
        return format
    }()
    
    public var colorCurrentDate: UIColor = .white
    public var colorBackgroundCurrentDate: UIColor = .systemRed
    public var colorBackgroundSelectDate: UIColor = .black
    public var colorSelectDate: UIColor = .white
    public var colorWeekendDate: UIColor = .gray
    public var colorBackgroundWeekendDate: UIColor = .clear
    public var weekFontPad: UIFont = .boldSystemFont(ofSize: 14)
    public var weekFontPhone: UIFont = .boldSystemFont(ofSize: 8)
    public var weekFont: UIFont {
        switch Platform.currentInterface {
        case .phone:
            return weekFontPhone
        default:
            return weekFontPad
        }
    }
    public var fontTitle: UIFont = .systemFont(ofSize: 19)
    public var colorTitle: UIColor = .black
    public var colorBackgroundHeader: UIColor = gainsboro.withAlphaComponent(0.2)
    public var fontTitleHeader: UIFont = .boldSystemFont(ofSize: 40)
    public var colorTitleHeader: UIColor = .black
    public var heightTitleHeader: CGFloat = 50
    public var alignmentTitleHeader: NSTextAlignment = .left
    public var fontDayTitlePad: UIFont = .systemFont(ofSize: 15)
    public var fontDayTitlePhone: UIFont = .systemFont(ofSize: 11)
    public var fontDayTitle: UIFont {
        switch Platform.currentInterface {
        case .phone:
            return fontDayTitlePhone
        default:
            return fontDayTitlePad
        }
    }
    public var colorDayTitle: UIColor = .black
    public var selectCalendarType: CalendarType = .month
    public var isAnimateSelection: Bool = false
    public var isPagingEnabled: Bool = true
    public var autoSelectionDateWhenScrolling: Bool = true
    public var weekDayAlignment: NSTextAlignment = .center
    public var titleDateAlignment: NSTextAlignment = .left
    public var colorBackground: UIColor = .white
    
    var scrollDirection: UICollectionView.ScrollDirection = .vertical
}

// MARK: All Day style

public struct AllDayStyle {
    public var backgroundColor: UIColor = gainsboro
    public var titleText: String = "all-day"
    public var titleColor: UIColor = .black
    public var titleAlignment: NSTextAlignment = .center
    public var textColor: UIColor = .black
    public var offsetWidth: CGFloat = 2
    public var offsetHeight: CGFloat = 2
    public var offsetX: CGFloat = 0
    public var height: CGFloat = 25
    public var maxHeight: CGFloat = 70
    public var fontTitle: UIFont = .systemFont(ofSize: 10)
    public var isPinned: Bool = true
    public var eventCorners: UIRectCorner = .allCorners
    public var eventCornersRadius: CGSize = CGSize(width: 5, height: 5)
    public var isHiddenStubEvent: Bool = true

    @available(swift, deprecated: 0.5.0)
    public enum AxisMode: Int {
        case horizontal, vertical
    }
}

// MARK: Event style

public struct EventStyle {
    public var minimumPressDuration: TimeInterval = 0.5
    public var alphaWhileMoving: CGFloat = 0.5
    public var textForNewEvent: String = "New Event"
    public var iconFile: UIImage? = nil
    public var colorIconFile: UIColor = .black
    public var isEnableVisualSelect: Bool = true
    public var colorStubView: UIColor? = nil
    public var heightStubView: CGFloat = 5
    public var alignmentStubView: NSLayoutConstraint.Axis = .vertical
    public var spacingStubView: CGFloat = 1
    public var eventCorners: UIRectCorner = .allCorners
    public var eventCornersRadius: CGSize = CGSize(width: 2.5, height: 2.5)
    public var delayForStartMove: TimeInterval = 1.5
    public var states: Set<EventViewGeneral.EventViewState> = [.move, .resize]
    public var defaultHeight: CGFloat? = nil
    public var showRecurringEventInPast: Bool = false
    public var textContainerInset: UIEdgeInsets = .zero
    public var newEventStep: Int = 15
    
    /// work only together with the `Week.viewMode = .list` property
    public var defaultWidth: CGFloat? = nil
}

// MARK: List View Style

public struct ListViewStyle {
    public var fontBullet: UIFont = .boldSystemFont(ofSize: 50)
    public var fontTitle: UIFont = .systemFont(ofSize: 17)
    public var heightHeaderView: CGFloat? = 50
    public var backgroundColor: UIColor = .white
    public var headerDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
}

extension Style {
    var adaptiveStyle: Style {
        guard followInSystemTheme else { return self }
        
        var newStyle = self
        // event
        newStyle.event.colorIconFile = UIColor.useForStyle(dark: .systemGray, white: newStyle.event.colorIconFile)
        
        // header
        newStyle.headerScroll.colorNameEmptyDay = UIColor.useForStyle(dark: .systemGray6,
                                                                      white: newStyle.headerScroll.colorNameEmptyDay)
        newStyle.headerScroll.colorBackground = UIColor.useForStyle(dark: .black, white: newStyle.headerScroll.colorBackground)
        newStyle.headerScroll.titleDateColor = UIColor.useForStyle(dark: .white, white: newStyle.headerScroll.titleDateColor)
        newStyle.headerScroll.titleDateColorCorner = UIColor.useForStyle(dark: .systemRed,
                                                                         white: newStyle.headerScroll.titleDateColorCorner)
        newStyle.headerScroll.colorDate = UIColor.useForStyle(dark: .white, white: newStyle.headerScroll.colorDate)
        newStyle.headerScroll.colorNameDay = UIColor.useForStyle(dark: .white, white: newStyle.headerScroll.colorNameDay)
        newStyle.headerScroll.colorCurrentDate = UIColor.useForStyle(dark: .systemGray6,
                                                                     white: newStyle.headerScroll.colorCurrentDate)
        newStyle.headerScroll.colorBackgroundCurrentDate = UIColor.useForStyle(dark: .systemRed,
                                                                               white: newStyle.headerScroll.colorBackgroundCurrentDate)
        newStyle.headerScroll.colorBackgroundSelectDate = UIColor.useForStyle(dark: .white,
                                                                              white: newStyle.headerScroll.colorBackgroundSelectDate)
        newStyle.headerScroll.colorSelectDate = UIColor.useForStyle(dark: .black, white: newStyle.headerScroll.colorSelectDate)
        newStyle.headerScroll.colorCurrentSelectDateForDarkStyle = UIColor.useForStyle(dark: .white,
                                                                                       white: newStyle.headerScroll.colorCurrentSelectDateForDarkStyle)
        newStyle.headerScroll.colorWeekendDate = UIColor.useForStyle(dark: .systemGray2,
                                                                     white: newStyle.headerScroll.colorWeekendDate)
        newStyle.headerScroll.bottomLineColor = UIColor.useForStyle(dark: .systemGray2,
                                                                    white: newStyle.headerScroll.bottomLineColor)
        
        // timeline
        newStyle.timeline.backgroundColor = UIColor.useForStyle(dark: .black, white: newStyle.timeline.backgroundColor)
        newStyle.timeline.timeColor = UIColor.useForStyle(dark: .systemGray, white: newStyle.timeline.timeColor)
        newStyle.timeline.timeSuffixColor = UIColor.useForStyle(dark: .systemGray2, white: newStyle.timeline.timeColor)
        
        switch newStyle.timeline.currentLineHourStyle {
        case .ios18AndHigher(var item):
            item.lineColor = UIColor.useForStyle(
                dark: .systemRed,
                white: newStyle.timeline.currentLineHourStyle.style.lineColor
            )
            item.timeColor = UIColor.useForStyle(
                dark: .white,
                white: newStyle.timeline.currentLineHourStyle.style.timeColor
            )
            newStyle.timeline.currentLineHourStyle = .ios18AndHigher(item)
        case .ios17AndLower(var item):
            item.lineColor = UIColor.useForStyle(
                dark: .systemRed,
                white: newStyle.timeline.currentLineHourStyle.style.lineColor
            )
            newStyle.timeline.currentLineHourStyle = .ios17AndLower(item)
        }
        
        // week
        newStyle.week.colorBackground = UIColor.useForStyle(dark: .black, white: newStyle.week.colorBackground)
        newStyle.week.colorDate = UIColor.useForStyle(dark: .white, white: newStyle.week.colorDate)
        newStyle.week.colorNameDay = UIColor.useForStyle(dark: .systemGray, white: newStyle.week.colorNameDay)
        newStyle.week.colorCurrentDate = UIColor.useForStyle(dark: .systemGray, white: newStyle.week.colorCurrentDate)
        newStyle.week.colorBackgroundSelectDate = UIColor.useForStyle(dark: .systemGray,
                                                                      white: newStyle.week.colorBackgroundSelectDate)
        newStyle.week.colorBackgroundCurrentDate = UIColor.useForStyle(dark: .systemGray,
                                                                       white: newStyle.week.colorBackgroundCurrentDate)
        newStyle.week.colorSelectDate = UIColor.useForStyle(dark: .white, white: newStyle.week.colorSelectDate)
        newStyle.week.colorWeekendDate = UIColor.useForStyle(dark: .systemGray2, white: newStyle.week.colorWeekendDate)
        newStyle.week.colorWeekendBackground = UIColor.useForStyle(dark: .clear, white: newStyle.week.colorWeekendBackground)
        newStyle.week.colorWeekdayBackground = UIColor.useForStyle(dark: .clear, white: newStyle.week.colorWeekdayBackground)
        
        // month
        newStyle.month.colorDate = UIColor.useForStyle(dark: .white, white: newStyle.month.colorDate)
        newStyle.month.colorNameEmptyDay = UIColor.useForStyle(dark: .systemGray6, white: newStyle.month.colorNameEmptyDay)
        newStyle.month.colorCurrentDate = UIColor.useForStyle(dark: .white, white: newStyle.month.colorCurrentDate)
        newStyle.month.colorBackgroundCurrentDate = UIColor.useForStyle(dark: .systemRed,
                                                                        white: newStyle.month.colorBackgroundCurrentDate)
        newStyle.month.colorBackgroundSelectDate = UIColor.useForStyle(dark: .white,
                                                                       white: newStyle.month.colorBackgroundSelectDate)
        newStyle.month.colorSelectDate = UIColor.useForStyle(dark: .black, white: newStyle.month.colorSelectDate)
        newStyle.month.colorWeekendDate = UIColor.useForStyle(dark: .systemGray2, white: newStyle.month.colorWeekendDate)
        newStyle.month.colorMoreTitle = UIColor.useForStyle(dark: .systemGray3, white: newStyle.month.colorMoreTitle)
        newStyle.month.colorEventTitle = UIColor.useForStyle(dark: .systemGray, white: newStyle.month.colorEventTitle)
        if Platform.currentInterface == .phone {
            newStyle.month.colorSeparator = UIColor.useForStyle(dark: .systemGray4, white: newStyle.month.colorSeparator)
            newStyle.month.colorBackgroundWeekendDate = UIColor.useForStyle(dark: .black,
                                                                            white: newStyle.month.colorBackgroundWeekendDate)
        } else {
            newStyle.month.colorSeparator = UIColor.useForStyle(dark: .systemGray, white: newStyle.month.colorSeparator)
            newStyle.month.colorBackgroundWeekendDate = UIColor.useForStyle(dark: .systemGray6,
                                                                            white: newStyle.month.colorBackgroundWeekendDate)
        }
        newStyle.month.colorBackgroundDate = UIColor.useForStyle(dark: .black, white: newStyle.month.colorBackgroundDate)
        newStyle.month.colorTitleHeader = UIColor.useForStyle(dark: .white, white: newStyle.month.colorTitleHeader)
        newStyle.month.colorBackground = UIColor.useForStyle(dark: .black, white: newStyle.month.colorBackground)
        newStyle.month.colorTitleCurrentDate = .useForStyle(dark: .systemRed, white: newStyle.month.colorTitleCurrentDate)
        
        // year
        newStyle.year.colorCurrentDate = UIColor.useForStyle(dark: .white, white: newStyle.year.colorCurrentDate)
        newStyle.year.colorBackgroundCurrentDate = UIColor.useForStyle(dark: .systemRed,
                                                                       white: newStyle.year.colorBackgroundCurrentDate)
        newStyle.year.colorBackgroundSelectDate = UIColor.useForStyle(dark: .systemGray,
                                                                      white: newStyle.year.colorBackgroundSelectDate)
        newStyle.year.colorSelectDate = UIColor.useForStyle(dark: .white, white: newStyle.year.colorSelectDate)
        newStyle.year.colorWeekendDate = UIColor.useForStyle(dark: .systemGray2, white: newStyle.year.colorWeekendDate)
        newStyle.year.colorBackgroundWeekendDate = UIColor.useForStyle(dark: .clear,
                                                                       white: newStyle.year.colorBackgroundWeekendDate)
        newStyle.year.colorTitle = UIColor.useForStyle(dark: .white, white: newStyle.year.colorTitle)
        newStyle.year.colorBackgroundHeader = UIColor.useForStyle(dark: .black, white: newStyle.year.colorBackgroundHeader)
        newStyle.year.colorTitleHeader = UIColor.useForStyle(dark: .white, white: newStyle.year.colorTitleHeader)
        newStyle.year.colorDayTitle = UIColor.useForStyle(dark: .systemGray, white: newStyle.year.colorDayTitle)
        newStyle.year.colorBackground = UIColor.useForStyle(dark: .black, white: newStyle.year.colorBackground)
        
        // all day
        newStyle.allDay.backgroundColor = UIColor.useForStyle(dark: .systemGray6, white: newStyle.allDay.backgroundColor)
        newStyle.allDay.titleColor = UIColor.useForStyle(dark: .white, white: newStyle.allDay.titleColor)
        newStyle.allDay.textColor = UIColor.useForStyle(dark: .white, white: newStyle.allDay.textColor)
        
        // list view
        newStyle.list.backgroundColor = UIColor.useForStyle(dark: .black, white: newStyle.list.backgroundColor)
        return newStyle
    }
}

extension Style: Equatable {
    
    public static func == (lhs: Style, rhs: Style) -> Bool {
        func compare<E: Equatable>(_ kp: KeyPath<Style, E>) -> Bool {
            return lhs[keyPath: kp] == rhs[keyPath: kp]
        }
        
        return compare(\.event)
        && compare(\.timeline)
        && compare(\.allDay)
        && compare(\.week)
        && compare(\.headerScroll)
        && compare(\.month)
        && compare(\.year)
        && compare(\.list)
        && compare(\.locale)
        && compare(\.timezone)
        && compare(\.defaultType)
        && compare(\.timeSystem)
        && compare(\.isEndOfDayZero)
        && compare(\.startWeekDay)
        && compare(\.followInSystemTheme)
        && compare(\.systemCalendars)
    }
    
}

extension YearStyle: Equatable {
    
    public static func == (lhs: YearStyle, rhs: YearStyle) -> Bool {
        func compare<E: Equatable>(_ kp: KeyPath<YearStyle, E>) -> Bool {
            return lhs[keyPath: kp] == rhs[keyPath: kp]
        }
        
        return compare(\.titleFormatter)
        && compare(\.weekdayFormatter)
        && compare(\.colorCurrentDate)
        && compare(\.colorBackgroundCurrentDate)
        && compare(\.colorBackgroundSelectDate)
        && compare(\.colorSelectDate)
        && compare(\.colorWeekendDate)
        && compare(\.colorBackgroundWeekendDate)
        && compare(\.weekFontPad)
        && compare(\.weekFontPhone)
        && compare(\.weekFont)
        && compare(\.fontTitle)
        && compare(\.colorTitle)
        && compare(\.colorBackgroundHeader)
        && compare(\.fontTitleHeader)
        && compare(\.colorTitleHeader)
        && compare(\.heightTitleHeader)
        && compare(\.alignmentTitleHeader)
        && compare(\.fontDayTitlePad)
        && compare(\.fontDayTitlePhone)
        && compare(\.fontDayTitle)
        && compare(\.colorDayTitle)
        && compare(\.selectCalendarType)
        && compare(\.isAnimateSelection)
        && compare(\.isPagingEnabled)
        && compare(\.autoSelectionDateWhenScrolling)
        && compare(\.weekDayAlignment)
        && compare(\.titleDateAlignment)
        && compare(\.colorBackground)
        && compare(\.scrollDirection)
        && compare(\.weekDayAlignment)
    }
    
}

extension MonthStyle: Equatable {
    
    public static func == (lhs: MonthStyle, rhs: MonthStyle) -> Bool {
        func compare<E: Equatable>(_ kp: KeyPath<MonthStyle, E>) -> Bool {
            return lhs[keyPath: kp] == rhs[keyPath: kp]
        }
        
        return compare(\.titleFormatter)
        && compare(\.weekdayFormatter)
        && compare(\.shortInDayMonthFormatter)
        && compare(\.heightHeaderWeek)
        && compare(\.heightTitleHeader)
        && compare(\.isHiddenTitleHeader)
        && compare(\.colorDate)
        && compare(\.colorNameEmptyDay)
        && compare(\.fontNameDate)
        && compare(\.colorCurrentDate)
        && compare(\.colorBackgroundCurrentDate)
        && compare(\.colorBackgroundSelectDate)
        && compare(\.colorSelectDate)
        && compare(\.colorWeekendDate)
        && compare(\.moreTitle)
        && compare(\.isHiddenMoreTitle)
        && compare(\.colorMoreTitle)
        && compare(\.colorEventTitle)
        && compare(\.weekFont)
        && compare(\.fontEventTitle)
        && compare(\.fontEventTime)
        && compare(\.fontEventBullet)
        && compare(\.isHiddenSeparator)
        && compare(\.isHiddenSeparatorOnEmptyDate)
        && compare(\.widthSeparator)
        && compare(\.colorSeparator)
        && compare(\.colorBackgroundWeekendDate)
        && compare(\.colorBackgroundDate)
        && compare(\.scrollDirection)
        && compare(\.selectCalendarType)
        && compare(\.isAnimateSelection)
        && compare(\.isPagingEnabled)
        && compare(\.isScrollEnabled)
        && compare(\.autoSelectionDateWhenScrolling)
        && compare(\.eventCorners)
        && compare(\.eventCornersRadius)
        && compare(\.isHiddenDotInTitle)
        && compare(\.isHiddenEventTitle)
        && compare(\.weekDayAlignment)
        && compare(\.titleHeaderAlignment)
        && compare(\.fontTitleHeader)
        && compare(\.colorTitleHeader)
        && compare(\.colorTitleCurrentDate)
        && compare(\.showDatesForOtherMonths)
        && compare(\.colorBackground)
        && compare(\.selectionMode)
        && compare(\.showMonthNameInFirstDay)
        && compare(\.isPrefetchingEnabled)
        && compare(\.isHiddenSectionHeader)
        && compare(\.heightSectionHeader)
    }
    
}

extension ListViewStyle: Equatable {
    
    public static func == (lhs: ListViewStyle, rhs: ListViewStyle) -> Bool {
        func compare<E: Equatable>(_ kp: KeyPath<ListViewStyle, E>) -> Bool {
            return lhs[keyPath: kp] == rhs[keyPath: kp]
        }
        
        return compare(\.fontBullet)
        && compare(\.fontTitle)
        && compare(\.heightHeaderView)
        && compare(\.backgroundColor)
        && compare(\.headerDateFormatter)
    }
    
}

extension HeaderScrollStyle: Equatable {
    
    public static func == (lhs: HeaderScrollStyle, rhs: HeaderScrollStyle) -> Bool {
        func compare<E: Equatable>(_ kp: KeyPath<HeaderScrollStyle, E>) -> Bool {
            return lhs[keyPath: kp] == rhs[keyPath: kp]
        }
        
        return compare(\.titleDays)
        && compare(\.heightHeaderWeek)
        && compare(\.heightSubviewHeader)
        && compare(\.colorBackground)
        && compare(\.isHiddenSubview)
        && compare(\.titleFormatter)
        && compare(\.weekdayFormatter)
        && compare(\.titleDateColor)
        && compare(\.titleDateColorCorner)
        && compare(\.colorDate)
        && compare(\.fontDate)
        && compare(\.colorNameDay)
        && compare(\.fontNameDay)
        && compare(\.colorCurrentDate)
        && compare(\.colorBackgroundCurrentDate)
        && compare(\.colorBackgroundSelectDate)
        && compare(\.colorSelectDate)
        && compare(\.colorCurrentSelectDateForDarkStyle)
        && compare(\.colorWeekendDate)
        && compare(\.isScrollEnabled)
        && compare(\.colorWeekdayBackground)
        && compare(\.colorWeekendBackground)
        && compare(\.isHidden)
        && compare(\.dotCorners)
        && compare(\.dotCornersRadius)
        && compare(\.titleDateAlignment)
        && compare(\.titleDateFont)
        && compare(\.isAnimateTitleDate)
        && compare(\.colorNameEmptyDay)
        && compare(\.showDatesForOtherMonths)
        && compare(\.isAnimateSelection)
        && compare(\.shouldTimelineTrackScroll)
        && compare(\.bottomLineColor)
    }
    
}

extension WeekStyle: Equatable {
    
    public static func == (lhs: WeekStyle, rhs: WeekStyle) -> Bool {
        func compare<E: Equatable>(_ kp: KeyPath<WeekStyle, E>) -> Bool {
            return lhs[keyPath: kp] == rhs[keyPath: kp]
        }
        
        return compare(\.colorBackground)
        && compare(\.colorDate)
        && compare(\.colorNameDay)
        && compare(\.colorCurrentDate)
        && compare(\.colorBackgroundCurrentDate)
        && compare(\.colorBackgroundSelectDate)
        && compare(\.colorSelectDate)
        && compare(\.colorWeekendDate)
        && compare(\.colorWeekendBackground)
        && compare(\.colorWeekdayBackground)
        && compare(\.selectCalendarType)
        && compare(\.showVerticalDayDivider)
        && compare(\.daysInOneWeek)
        && compare(\.maxDays)
    }
    
}

extension AllDayStyle: Equatable {
    
    public static func == (lhs: AllDayStyle, rhs: AllDayStyle) -> Bool {
        func compare<E: Equatable>(_ kp: KeyPath<AllDayStyle, E>) -> Bool {
            return lhs[keyPath: kp] == rhs[keyPath: kp]
        }
        
        return compare(\.backgroundColor)
        && compare(\.titleText)
        && compare(\.titleColor)
        && compare(\.titleAlignment)
        && compare(\.textColor)
        && compare(\.offsetWidth)
        && compare(\.offsetHeight)
        && compare(\.offsetX)
        && compare(\.height)
        && compare(\.maxHeight)
        && compare(\.fontTitle)
        && compare(\.isPinned)
        && compare(\.eventCorners)
        && compare(\.eventCornersRadius)
        && compare(\.isHiddenStubEvent)
    }
    
}

extension TimelineStyle: Equatable {
    
    public static func == (lhs: TimelineStyle, rhs: TimelineStyle) -> Bool {
        func compare<E: Equatable>(_ kp: KeyPath<TimelineStyle, E>) -> Bool {
            return lhs[keyPath: kp] == rhs[keyPath: kp]
        }
        
        return compare(\.minimumPressDuration)
        && compare(\.startFromFirstEvent)
        && compare(\.eventFont)
        && compare(\.offsetEvent)
        && compare(\.startHour)
        && compare(\.endHour)
        && compare(\.scrollToHour)
        && compare(\.heightLine)
        && compare(\.movingMinuteLabelRoundUpTime)
        && compare(\.minuteLabelRoundUpTime)
        && compare(\.widthLine)
        && compare(\.offsetTop)
        && compare(\.offsetLineLeft)
        && compare(\.offsetLineRight)
        && compare(\.backgroundColor)
        && compare(\.widthTime)
        && compare(\.heightTime)
        && compare(\.offsetTimeX)
        && compare(\.offsetTimeY)
        && compare(\.timeColor)
        && compare(\.timeAlignment)
        && compare(\.timeFont)
        && compare(\.widthEventViewer)
        && compare(\.showLineHourMode)
        && compare(\.scrollLineHourMode)
        && compare(\.currentLineHourStyle)
        && compare(\.separatorLineColor)
        && compare(\.movingMinutesColor)
        && compare(\.shadowColumnColor)
        && compare(\.shadowColumnAlpha)
        && compare(\.minimumPressDuration)
        && compare(\.isHiddenStubEvent)
        && compare(\.isEnabledCreateNewEvent)
        && compare(\.isEnabledDefaultTapGestureRecognizer)
        && compare(\.maxLimitCachedPages)
        && compare(\.scrollDirections)
        && compare(\.dividerType)
        && compare(\.timeDividerColor)
        && compare(\.timeDividerFont)
        && compare(\.scale)
        && compare(\.createNewEventMethod)
        && compare(\.isEnabledForceDeselectEvent)
        && compare(\.isHiddenTimeVerticalSeparateLine)
    }
    
}

extension TimelineStyle.Scale: Equatable {
    
    public static func == (lhs: TimelineStyle.Scale, rhs: TimelineStyle.Scale) -> Bool {
        lhs.max == rhs.max && lhs.min == rhs.min
    }
    
}

extension EventStyle: Equatable {
    
    public static func == (lhs: EventStyle, rhs: EventStyle) -> Bool {
        func compare<E: Equatable>(_ kp: KeyPath<EventStyle, E>) -> Bool {
            return lhs[keyPath: kp] == rhs[keyPath: kp]
        }
        
        return compare(\.minimumPressDuration)
        && compare(\.alphaWhileMoving)
        && compare(\.textForNewEvent)
        && compare(\.iconFile)
        && compare(\.colorIconFile)
        && compare(\.isEnableVisualSelect)
        && compare(\.colorStubView)
        && compare(\.heightStubView)
        && compare(\.alignmentStubView)
        && compare(\.spacingStubView)
        && compare(\.eventCorners)
        && compare(\.eventCornersRadius)
        && compare(\.delayForStartMove)
        && compare(\.states)
        && compare(\.defaultHeight)
        && compare(\.showRecurringEventInPast)
        && compare(\.textContainerInset)
        && compare(\.newEventStep)
        && compare(\.defaultWidth)
    }
    
}

#endif
